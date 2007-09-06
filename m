Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbXIFOGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbXIFOGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 10:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXIFOGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 10:06:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35559 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbXIFOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 10:06:46 -0400
Message-ID: <46E00962.7080903@zytor.com>
Date: Thu, 06 Sep 2007 15:06:26 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
References: <20070831201820.GF31970@nostromo.devel.redhat.com> <46D9D587.9020605@zytor.com> <Pine.LNX.4.64.0709061404120.25942@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709061404120.25942@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> sysfs, and you were on the discussion (your idea won, basically....)
> And the way I see it, it got merged.
> Commit 042f10ec6533e53181284c96d22ae051e49ac707
> 
> As I further see it, this CONFIG_VT_UNICODE patch defines the 
> starting value for the default.
> 
> E.g. CONFIG_VT_UNICODE=y, you start with utf8, and can, at will, at 
> runtime, change it. CONFIG_VT_UNICODE=n, you start with 8bit, and can, 
> at will, at runtime, too, change it ;-)
> 

Hmmm...

Personally I'd suggest making it the default unless overridden in 
/etc/sysctl.conf.  My second preference would be a command-line option, 
not a compile-time default.

This is 2007, after all, and it seems Unicode should be the default, 
anything else legacy...

	-hpa
