Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbYBFLLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbYBFLLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYBFLLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:11:34 -0500
Received: from smtp27.orange.fr ([80.12.242.95]:56217 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbYBFLLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:11:33 -0500
X-ME-UUID: 20080206111130123.1E3FB1C001AF@mwinf2707.orange.fr
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Xavier Bestel <xavier.bestel@free.fr>
To: Adrian Bunk <bunk@kernel.org>
Cc: Pavel Roskin <proski@gnu.org>, rms@gnu.org, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, rusty@rustcorp.com.au, pgiri@yahoo.com
In-Reply-To: <20080206105051.GA13874@cs181133002.pp.htv.fi>
References: <1201641765.18773.35.camel@dv>
	 <20080129225701.GS8767@does.not.exist> <1201650267.18773.118.camel@dv>
	 <E1JKJvh-0006P8-Pi@fencepost.gnu.org> <1201842510.18433.88.camel@dv>
	 <20080206105051.GA13874@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 12:11:13 +0100
Message-Id: <1202296273.23816.63.camel@skunk.anacadf.mentorg.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-06 at 12:50 +0200, Adrian Bunk wrote:
> The Linux kernel is licenced under the GPLv2.
> 
> Ndiswrapper loads and executes code with not GPLv2 compatible
> licences 
> in a way in the kernel that might be considered similar to a GPLv2'ed 
> userspace program dlopen() a dynamic library file with a not GPLv2 
> compatible licence.
> 
> IANAL, but I do think there might be real copyright issues with 
> ndiswrapper. 

There are issue as soon as ndiswrapper loads a proprietary NDIS. But a
system with just ndiswrapper loaded shouldn't be tainted.

	Xav


