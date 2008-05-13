Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYEMJrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYEMJrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYEMJrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:47:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48927 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYEMJrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:47:11 -0400
Date: Tue, 13 May 2008 11:54:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Paulo Marques <pmarques@grupopie.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
Message-ID: <20080513095437.GJ31954@one.firstfloor.org>
References: <20080509174148.GA22246@basil.nowhere.org> <482491D6.9030205@grupopie.com> <4824A7B6.70306@firstfloor.org> <4824AD3C.3070506@grupopie.com> <20080509233742.GA22265@martell.zuzino.mipt.ru> <48281540.9020207@grupopie.com> <20080512155052.GB6913@cvg> <20080512172323.GA9236@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512172323.GA9236@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I expect it to be a toolchain issue. Andi is often running with gcc versions
> that are very new (fresh from svn maybe). I dunno about binutils.

No actually that's a pretty old version from SUSE 10.2

gcc-4.1.3-29
binutils-2.17.50.0.5-21

This means i've been recently trying to get the x86-64 kernel to work
with the new gold linker from binutils mainline, but it's far from
booting yet and was not used here.

> To reproduce I would expect that a very recent gcc/binutils is needed.
> Andi?

Just a SUSE 10.2 toolchain. You can probably rpm2cpio it from any 
SUSE mirror.

-Andi
