Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbXJUSSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbXJUSSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 14:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbXJUSSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 14:18:37 -0400
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:20687 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbXJUSSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 14:18:36 -0400
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: kbuild: disable depmod in cross-compile kernel build
Cc: akuster@mvista.com, bunk@kernel.org, dsaxena@mvista.com,
       linux-kernel@vger.kernel.org, nafallo@magicalforest.se,
       sam@ravnborg.org
In-reply-To: <Pine.LNX.4.64.0710211948450.6155@anakin>
References: <200710192259.l9JMxENl018922@hera.kernel.org> <Pine.LNX.4.64.0710211948450.6155@anakin>
Message-Id: <E1IjfNc-0006rv-9k@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sun, 21 Oct 2007 20:18:28 +0200
X-OriginalArrivalTime: 21 Oct 2007 18:18:30.0431 (UTC) FILETIME=[C86662F0:01C8140E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> Euh, is these really necessary?
> 
> At work I have no problems running depmod on an i386 system for ppc64
> modules after I installed module-init-tools 3.3-pre2 (from Debian).

That's right. I do depmod on i386 and amd64 for _all_ Debian architectures 
without any problems and I don't see why it should be a problem when running 
on other arches. It used to be a problem with depmod from modutils, but with 
depmod from module-init-tools it works perfectly.

All it needs is the -b option and correct kernel version.
