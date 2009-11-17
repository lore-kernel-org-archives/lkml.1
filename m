Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZKQRZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZKQRZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZKQRZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:25:10 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52756 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbZKQRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:25:09 -0500
Date: Tue, 17 Nov 2009 12:25:15 -0500
To: Valdis.Kletnieks@vt.edu
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091117172515.GI15159@caffeine.csclub.uwaterloo.ca>
References: <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <20091112121805.GF1394@ucw.cz> <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca> <20091113165730.0b9b2676@lxorguk.ukuu.org.uk> <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca> <20091113212148.5cb829d4@lxorguk.ukuu.org.uk> <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca> <20091117115929.4ba23c49@lxorguk.ukuu.org.uk> <7332.1258476527@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7332.1258476527@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 11:48:47AM -0500, Valdis.Kletnieks@vt.edu wrote:
> Umm...  'modprobe msr'?
> 
> (Recently I had what *looked* like an xorg server bug, turned out to be a
> missing CONFIG_INPUT_EVDEV.. Whoops. ;)

I did.  Makes no difference.  If I unload it I get the same error.

# modinfo msr
filename:       /lib/modules/2.6.26-2-gx1/kernel/arch/x86/kernel/msr.ko
author:         H. Peter Anvin <hpa@zytor.com>
description:    x86 generic MSR driver
license:        GPL
vermagic:       2.6.26-2-gx1 mod_unload GEODEGX1
depends:

# lsmod |grep msr
msr                     2692  0

I don't get it.

-- 
Len Sorensen
