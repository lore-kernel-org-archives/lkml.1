Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbZAMRp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbZAMRp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZAMRpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:45:11 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:46975 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbZAMRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:45:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:message-id:in-reply-to:references:date
         :subject:to:user-agent:mime-version:content-type
         :content-transfer-encoding:x-priority:importance:from;
        b=v8qG+30uBGdWsK3B9/fBHlV+0mcXXhcRoo0mnwLnj1DVtKTZLg3kKAEv6zf2WbRZXY
         THwGZzMcDZL2y4LK/v3Ew8EozPVfm6T7gYZE7HpJ1wjqWkBkElFaw//2mUypXwvjOJCB
         g1qajcX1qX6RFzxZikS/LRSX9OougKxGIGmt0=
Message-ID: <1abb5d601cc91bdaa406e206cb92094f.squirrel@localhost>
In-Reply-To: <20090113123056.GA2464@deprecation.cyrius.com>
References: <200901121356.46236.elendil@planet.nl>
    <20090113123056.GA2464@deprecation.cyrius.com>
Date: Tue, 13 Jan 2009 11:45:01 -0600 (CST)
Subject: Git as of 13-Jan-2009 build fail on OMAP3
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.16-1.fc10
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
From: david.hagood@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am attempting to build the stock kernel as pulled from the kernel GIT
server for an OMAP3 platform, and am getting errors.

The version I am working with (as displayed by "git show") is "commit
e0b325d310a6b11f1538413fd557d2eb98f2fae5".

The error is:


  CC      arch/arm/mach-omap2/board-omap3beagle.o
arch/arm/mach-omap2/board-omap3beagle.c: In function ‘beagle_twl_gpio_setup’:
arch/arm/mach-omap2/board-omap3beagle.c:132: error: ‘TWL4030_GPIO_MAX’
undeclared (first use in this function)
arch/arm/mach-omap2/board-omap3beagle.c:132: error: (Each undeclared
identifier is reported only once
arch/arm/mach-omap2/board-omap3beagle.c:132: error: for each function it
appears in.)
arch/arm/mach-omap2/board-omap3beagle.c: At top level:
arch/arm/mach-omap2/board-omap3beagle.c:141: error: variable
‘beagle_gpio_data’ has initializer but incomplete type
arch/arm/mach-omap2/board-omap3beagle.c:142: error: unknown field
‘gpio_base’ specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:142: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:142: warning: (near initialization
for ‘beagle_gpio_data’)
arch/arm/mach-omap2/board-omap3beagle.c:143: error: unknown field
‘irq_base’ specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:143: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:143: warning: (near initialization
for ‘beagle_gpio_data’)
arch/arm/mach-omap2/board-omap3beagle.c:144: error: unknown field
‘irq_end’ specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:144: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:144: warning: (near initialization
for ‘beagle_gpio_data’)
arch/arm/mach-omap2/board-omap3beagle.c:145: error: unknown field
‘use_leds’ specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:145: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:145: warning: (near initialization
for ‘beagle_gpio_data’)
arch/arm/mach-omap2/board-omap3beagle.c:146: error: unknown field
‘pullups’ specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:146: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:146: warning: (near initialization
for ‘beagle_gpio_data’)
arch/arm/mach-omap2/board-omap3beagle.c:147: error: unknown field
‘pulldowns’ specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:148: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:148: warning: (near initialization
for ‘beagle_gpio_data’)
arch/arm/mach-omap2/board-omap3beagle.c:149: error: unknown field ‘setup’
specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:149: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:149: warning: (near initialization
for ‘beagle_gpio_data’)
arch/arm/mach-omap2/board-omap3beagle.c:152: error: variable
‘beagle_twldata’ has initializer but incomplete type
arch/arm/mach-omap2/board-omap3beagle.c:153: error: unknown field
‘irq_base’ specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:153: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:153: warning: (near initialization
for ‘beagle_twldata’)
arch/arm/mach-omap2/board-omap3beagle.c:154: error: unknown field
‘irq_end’ specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:154: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:154: warning: (near initialization
for ‘beagle_twldata’)
arch/arm/mach-omap2/board-omap3beagle.c:157: error: unknown field ‘gpio’
specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:157: warning: excess elements in
struct initializer
arch/arm/mach-omap2/board-omap3beagle.c:157: warning: (near initialization
for ‘beagle_twldata’)
arch/arm/mach-omap2/board-omap3beagle.c: In function ‘omap3_beagle_init’:
arch/arm/mach-omap2/board-omap3beagle.c:308: error: ‘gpio’ undeclared
(first use in this function)
make[1]: *** [arch/arm/mach-omap2/board-omap3beagle.o] Error 1
make: *** [arch/arm/mach-omap2] Error 2

I do have the TWL4030 enabled in the config.

Has anybody else tried this?

