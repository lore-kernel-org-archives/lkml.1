Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbXIDBiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbXIDBiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 21:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbXIDBiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 21:38:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55708 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXIDBiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 21:38:12 -0400
Date: Tue, 4 Sep 2007 02:38:11 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Pallewatta Mano-FPCD67 <Mano.Pallewatta@motorola.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-2.6.16.51 gzipped core dump patch
Message-ID: <20070904013811.GX21089@ftp.linux.org.uk>
References: <1188AA083E6C7C4EBCE34803004A84014FE921@de01exm72.ds.mot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188AA083E6C7C4EBCE34803004A84014FE921@de01exm72.ds.mot.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 08:49:00PM -0400, Pallewatta Mano-FPCD67 wrote:
> Hi,
> The attached patch is based on Jan Frey's previous patch posted in 2004
> for the Linux 2.4 kernel. It has been tested on X86 and MIPS platforms.
> If the core pattern doesn't end in ".gz" it will be added to the name of
> the core file. It's offered under GPL v2 without any warranties. If you
> have any questions, please contact me directly at Mano.Pallewatta "at"
> motorola.com. 

This is silly, IMO - why do in kernel what can be done in userland?  External
process can damn well gzip/bzip2/uuencode and post to alt.sex.cthulhu.binaries/
whatever.  Just feed the usual data to its stdin...
