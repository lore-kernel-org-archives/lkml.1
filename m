Return-Path: <linux-kernel-owner+w=401wt.eu-S933625AbXJPOol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbXJPOol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932540AbXJPOoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:44:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57328 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbXJPOob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:44:31 -0400
Date: Tue, 16 Oct 2007 16:44:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Rob Landley <rob@landley.net>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       randy.dunlap@oracle.com
Subject: Re: [PATCH] Allow kconfig to accept overrides
In-Reply-To: <20071016042957.GB27909@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0710161642560.10197@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
 <20071016042957.GB27909@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Oct 16 2007 06:29, Sam Ravnborg wrote:
>On Fri, Oct 12, 2007 at 11:44:08PM +0200, Jan Engelhardt wrote:
>> 
>> Allow config variables in .config to override earlier ones in the same
>> file. In other words,
>> 
>> 	# CONFIG_SECURITY is not defined
>> 	CONFIG_SECURITY=y
>> 
>> will activate it. This makes it a bit easier to do
>> 
>> 	(cat original-config myconfig myconfig2 ... >.config)
>> 
>> and run menuconfig as expected.
>
>
>How far is this from the miniconfig functionality?
>Is it the same or can we achieve the miniconfig support
>by extending Jan's patch?
>
>See: http://lkml.org/lkml/2007/10/12/391


miniconfig actually does something completely different as far as I
understand: miniconfig creates a minimal config that does not contain
default choices for CONFIG_ files, while the patch that I was trying
to submit here allows to override entries in a .config by just
appending them to the file. I already have a miniconfig, so to speak,
and want to merge it with the previous .config so as to produce a
fullconfig. (Something like the exact opposite)


thanks,
Jan
