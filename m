Return-Path: <linux-kernel-owner+w=401wt.eu-S964845AbXBZKBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbXBZKBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964852AbXBZKBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:01:21 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:40620 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964845AbXBZKBV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:01:21 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [ANNOUNCE] kvm-15 release
Date: Mon, 26 Feb 2007 02:01:22 -0800
Message-ID: <64F9B87B6B770947A9F8391472E032160A91C62A@ehost011-8.exch011.intermedia.net>
In-Reply-To: <45E2AD54.7020709@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [ANNOUNCE] kvm-15 release
Thread-Index: AcdZi4NquBRcYFkqRZuxBOkkFwg2WwAAWKlg
References: <45E16E54.60503@qumranet.com> <45E2AD54.7020709@suse.de>
From: "Dor Laor" <dor.laor@qumranet.com>
To: "Gerd Hoffmann" <kraxel@suse.de>, "Avi Kivity" <avik@qumranet.com>
Cc: "kvm-devel" <kvm-devel@lists.sourceforge.net>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Feb 2007 10:01:20.0371 (UTC) FILETIME=[1065B430:01C7598D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>Avi Kivity wrote:
>> - new userspace interface (work in progress)
>
>kvmfs in kvm-15 kernel code does not to build with older kernels
(2.6.16
>fails, 2.6.18 works ok), looks like the reason are some changes in
>superblock handling.
>
>Do you intend to fix that?

Did you run the make sync under the svn kernel directory?
It uses sed to replace the f_path.dentry with backward compatible
f_dentry.

>
>cheers,
>  Gerd
>
>--
>Gerd Hoffmann <kraxel@suse.de>
>
>-----------------------------------------------------------------------
--
>Take Surveys. Earn Cash. Influence the Future of IT
>Join SourceForge.net's Techsay panel and you'll get the chance to share
>your
>opinions on IT & business topics through brief surveys-and earn cash
>http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVD
EV
>_______________________________________________
>kvm-devel mailing list
>kvm-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/kvm-devel
