Return-Path: <linux-kernel-owner+w=401wt.eu-S933704AbXIUWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704AbXIUWyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765673AbXIUWjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:39:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:15089 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbXIUWjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:39:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,285,1186383600"; 
   d="scan'208";a="283936449"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Message codes (Re: [Announce] Linux-tiny project revival)
Date: Fri, 21 Sep 2007 15:39:06 -0700
Message-ID: <5389061B65D50446B1783B97DFDB392D0715BD20@orsmsx411.amr.corp.intel.com>
In-Reply-To: <1190413998.32660.67.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Message codes (Re: [Announce] Linux-tiny project revival)
thread-index: Acf8n2tNPlk5HvifRq2Ty63Sqaq1RwAAGVqA
References: <46F1645D.9050406@am.sony.com> <E1IYWps-0006fQ-83@flower> <5389061B65D50446B1783B97DFDB392D07126ACB@orsmsx411.amr.corp.intel.com> <200709211615.39898.rob@landley.net> <5389061B65D50446B1783B97DFDB392D0715BCA1@orsmsx411.amr.corp.intel.com> <1190413998.32660.67.camel@localhost>
From: "Gross, Mark" <mark.gross@intel.com>
To: "Joe Perches" <joe@perches.com>
Cc: "Rob Landley" <rob@landley.net>, "Oleg Verych" <olecom@flower.upol.cz>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Michael Opdenacker" <michael@free-electrons.com>,
       <linux-tiny@selenic.com>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Sep 2007 22:39:06.0973 (UTC) FILETIME=[381CD8D0:01C7FCA0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Joe Perches [mailto:joe@perches.com]
>Sent: Friday, September 21, 2007 3:33 PM
>To: Gross, Mark
>Cc: Rob Landley; Oleg Verych; Alexey Dobriyan; Michael Opdenacker;
linux-
>tiny@selenic.com; CE Linux Developers List; linux kernel
>Subject: RE: Message codes (Re: [Announce] Linux-tiny project revival)
>
>On Fri, 2007-09-21 at 15:12 -0700, Gross, Mark wrote:
>> Use compiler tricks to remove ALL the static printk string from
>> the kernel and replace the printk with something that outputs a
>> decimal index followed by tuples, of zero to N, hex-strings on
>
>> I proposed a mechanism for keeping all the printk data and saving
space
>> buy doing some table based compressions that has the side effect of
>> making the syslog not human readable.  You proposed a mechanism for
>> no-oping out complete log-levels.
>
>How about compiler tricks to compress the static printk strings?
>These could be expanded at runtime to use as the format.

You would have to hold the text table (compressed) in memory to do this
at run time.  That would still be pretty large hunk of memory.  

>
>Timothy Miller suggested something similar awhile ago.
