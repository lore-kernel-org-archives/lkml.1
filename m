Return-Path: <linux-kernel-owner+w=401wt.eu-S1764024AbXHQQzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764024AbXHQQzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbXHQQzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:55:11 -0400
Received: from smtp119.sbc.mail.re3.yahoo.com ([66.196.96.92]:21355 "HELO
	smtp119.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755433AbXHQQzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:55:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=K7Nhwpnz2JDvroa/YTMbvU9hPHI0mEw/zR+HbriHMw4UT2XyU9O+kCa+BIUGk1+sRxHjH51s6UFa6u9OPLtQnMXKdzeHl8C/o8/p6saclDIV+N94h2Sdl8CYvIP1rryHfmu74pNBNAm6aSSBW/FxYAiWAgaqj8Cwr3CxrWuzQe8=  ;
X-YMail-OSG: 9aICi_cVM1nVdzppqc9enDfA3SCunj8qUMQPy.gWggk_LhDCLuaKiBkGJNPNrBdTZZLsjuxs3Q--
From: David Brownell <david-b@pacbell.net>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Date: Fri, 17 Aug 2007 09:55:05 -0700
User-Agent: KMail/1.9.6
Cc: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>, jengelh@computergmbh.de,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, "Greg KH" <greg@kroah.com>
References: <200708170823.15894.david-b@pacbell.net> <20070818.011501.41012303.anemo@mba.ocn.ne.jp> <3ae72650708170932y5369213bq3479708216923edb@mail.gmail.com>
In-Reply-To: <3ae72650708170932y5369213bq3479708216923edb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708170955.06388.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Kay Sievers wrote:
> Again,

"Again"?


> the only sane solution is to provide MODALIAS="platform:<name>" 
> from the platform bus, and adding the aliases to drivers who support
> autoloading. Modalias strings are not free-text strings, they are
> required to be prefixed by the subsystem.

If so, then whoever tried to change the usage of module aliases
in that way goofed in several ways.  First, by not changing all
the in-kernel uses.  Second, by not changing all the out-of-tree
uses in various distros, toolchains, etc.  Third, by not even
documenting that change...

Module aliases have been around since very early versions of
stuff like "modprobe" ... without that new rule.  Aliases have
always been 	


> I still fail to see why platform must be different from everything
> else in the kernel.

It isn't.  See above.


> Please change that stuff, and the bugs which we 
> are fighting magically go away, because module-init-tools alias
> resolving works like it does for every other subsystem in the kernel.

Those bugs would be ... what?  "We" haven't observed anything
attributable to this usage, which has been common for years now.

- Dave

