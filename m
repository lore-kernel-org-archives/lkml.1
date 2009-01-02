Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbZABSMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbZABSMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbZABSMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:12:10 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:57676 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435AbZABSMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:12:09 -0500
Date: Fri, 2 Jan 2009 19:13:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>, Valdis.Kletnieks@vt.edu,
       Bryan Donlan <bdonlan@gmail.com>, Ingo Brueckl <ib@wupperonline.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Replace CONFIG_EMBEDDED [Was: x86 (Linux Tiny): configure out support for some processor]
Message-ID: <20090102181345.GB5905@uranus.ravnborg.org>
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu> <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com> <11444.1230910752@turing-police.cc.vt.edu> <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com> <20090102162120.GG1180@elte.hu> <3f9a31f40901020838v333a968dv937a717e031743eb@mail.gmail.com> <20090102173435.GE6759@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102173435.GE6759@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's a subjective category and no amount of talking will bring any 
> solution here.

It is brought up now and then partly because the use of the
term EMBEDDED that is so overloaded that it is not fun.

Someone should kill it and replace it with something saner.

CONFIG_EXPERT_TEXT_SIZE

For stuff that the expert can toy with which mainly
has text size impact and some documented performance/functionality impact.
The possibility to select a subset of CPU's may belong here.


CONFIG_EXPERT_DATA_SIZE

Likewise where what we save is more data than TEXT.
For example where we lower the size of a hash bucket etc.

CONFIG_EXPERT

For other stuff that no 'ordinary' user will need to change
but the expert may find it usefull.

Everything we hide under EMBEDDED today would fit in the
categories above.

	Sam
