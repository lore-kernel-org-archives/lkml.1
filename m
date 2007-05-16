Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbXEPByS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbXEPByS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 21:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbXEPByM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 21:54:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:51016 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbXEPByL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 21:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EtcV/uYAiq14jLcl97/YcTHCf8Z2GmnJzBW2p5SnxXVH0NSzhM0OR8y3++YjSxTbwaqFTpWjsABC+mHu2rIkEaL4GBrk0qhrrKGO2uODSaUkC9uDB3AO3TUJu6ThEVHf10Yzk3aA77yROUTPE8UZf/Se4J91ritpHsv/MRQ4W0A=
Message-ID: <a781481a0705151852x2786c0d7sc6a9b6b2a3695ca6@mail.gmail.com>
Date: Wed, 16 May 2007 07:22:42 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: Linux 2.6.22-rc1
Cc: "Tilman Schmidt" <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <Pine.LNX.4.61.0705151009400.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <4647569D.7010709@imap.cc>
	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
	 <4648A3DF.7040004@imap.cc>
	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
	 <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
	 <Pine.LNX.4.61.0705151009400.9570@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> [...]
> If you transform a menu with hidden options (which do NOT "depend on"
> the menu - they can't even) into a menuconfig (continuing not to
> depend on the menuconfig), the presentation fucks up (especially in
> ncurses-menuconfig). That is a good hint something should be taken
> more seriously.

Sorry, I didn't follow this "hidden options" thing at all ...

> So, for menus with hidden options I had a number of options how to
> go about them:
>
>  - move the hidden options before the menuconfig or after, so
>    the presentation does not bork;
>
>  - leave the menu as-is because there's just so many hidden
>    options and a menuconfig entry is detrimental

... but the second method seems sane and safe, still :-)

> So what do we need?
>
>  * 'configmenu' option (with 'endconfigmenu') that works the same as
>    'menu' and 'endmenu' (so we can have hidden options), but at the
>    same time make the ---> and options inside it disappear when it is
>    not selected. Currently, no other type seems to satisfy this.

(Yes, and with that implicit if-endif block to make "depends on" the
configmenu for those config options that are inside it automatic)

* Also, some "[MENU]" kind of prefix/tag in the text of configmenu
options would also be nice.

Satyam
