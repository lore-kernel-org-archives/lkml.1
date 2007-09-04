Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbXIDCcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbXIDCcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 22:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbXIDCcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 22:32:08 -0400
Received: from mail119.messagelabs.com ([216.82.241.179]:46104 "HELO
	mail119.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750902AbXIDCcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 22:32:05 -0400
X-VirusChecked: Checked
X-Env-Sender: Mano.Pallewatta@motorola.com
X-Msg-Ref: server-12.tower-119.messagelabs.com!1188873123!25800991!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [129.188.136.8]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] linux-2.6.16.51 gzipped core dump patch
Date: Mon, 3 Sep 2007 22:32:00 -0400
Message-ID: <1188AA083E6C7C4EBCE34803004A84014FE926@de01exm72.ds.mot.com>
In-Reply-To: <20070904013811.GX21089@ftp.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] linux-2.6.16.51 gzipped core dump patch
Thread-Index: AcfulEQqRT0O16g8RNyjHXmQ1x/oNAABWhPA
References: <1188AA083E6C7C4EBCE34803004A84014FE921@de01exm72.ds.mot.com> <20070904013811.GX21089@ftp.linux.org.uk>
From: "Pallewatta Mano-FPCD67" <Mano.Pallewatta@motorola.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was developed for embedded systems which had limited space
for file storage. If an external process is to compress core files you
will need to store those files somewhere first as core dump output
cannot be directly fed to the stdin of compression program. Imagine
storing a 40 Meg core file in an embedded system. A few core files will
fill up the file system and some core files can get corrupted too. 

Mano

-----Original Message-----
From: Al Viro [mailto:viro@ftp.linux.org.uk] 
Sent: Monday, September 03, 2007 6:38 PM
To: Pallewatta Mano-FPCD67
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-2.6.16.51 gzipped core dump patch

On Mon, Sep 03, 2007 at 08:49:00PM -0400, Pallewatta Mano-FPCD67 wrote:
> Hi,
> The attached patch is based on Jan Frey's previous patch posted in
2004
> for the Linux 2.4 kernel. It has been tested on X86 and MIPS
platforms.
> If the core pattern doesn't end in ".gz" it will be added to the name
of
> the core file. It's offered under GPL v2 without any warranties. If
you
> have any questions, please contact me directly at Mano.Pallewatta "at"
> motorola.com. 

This is silly, IMO - why do in kernel what can be done in userland?
External
process can damn well gzip/bzip2/uuencode and post to
alt.sex.cthulhu.binaries/
whatever.  Just feed the usual data to its stdin...
