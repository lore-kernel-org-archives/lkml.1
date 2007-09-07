Return-Path: <linux-kernel-owner+w=401wt.eu-S965326AbXIGLr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965326AbXIGLr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 07:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965205AbXIGLrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 07:47:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42336 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965203AbXIGLru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 07:47:50 -0400
Date: Fri, 7 Sep 2007 13:47:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
In-Reply-To: <46E00962.7080903@zytor.com>
Message-ID: <Pine.LNX.4.64.0709071347110.25942@fbirervta.pbzchgretzou.qr>
References: <20070831201820.GF31970@nostromo.devel.redhat.com>
 <46D9D587.9020605@zytor.com> <Pine.LNX.4.64.0709061404120.25942@fbirervta.pbzchgretzou.qr>
 <46E00962.7080903@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 6 2007 15:06, H. Peter Anvin wrote:
>> sysfs, and you were on the discussion (your idea won, basically....)
>> And the way I see it, it got merged.
>> Commit 042f10ec6533e53181284c96d22ae051e49ac707
>> 
>> As I further see it, this CONFIG_VT_UNICODE patch defines the starting value
>> for the default.
>> 
>> E.g. CONFIG_VT_UNICODE=y, you start with utf8, and can, at will, at runtime,
>> change it. CONFIG_VT_UNICODE=n, you start with 8bit, and can, at will, at
>> runtime, too, change it ;-)
>
> Hmmm...
>
> Personally I'd suggest making it the default unless overridden in
> /etc/sysctl.conf.  My second preference would be a command-line option, not a
> compile-time default.
>
> This is 2007, after all, and it seems Unicode should be the default, anything
> else legacy...

Yeah. You have a command line option already, called vt.default_utf={0|1}.


	Jan
-- 
