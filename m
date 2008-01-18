Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYARGvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYARGvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYARGvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:51:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53902 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYARGvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:51:12 -0500
Date: Fri, 18 Jan 2008 07:54:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make clflush a required feature on x86_64
Message-ID: <20080118065428.GA12594@one.firstfloor.org>
References: <20080118045921.GB974@phobos.i.cabal.ca> <p734pdbbrwu.fsf@bingen.suse.de> <20080118060124.GC1726@phobos.i.cabal.ca> <479046BA.7090903@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479046BA.7090903@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Simulators can be fixed, 

They could, but why? I don't know of a good reason to require CLFLUSH.

> I just verified that Bochs 2.3.0 lacks this CPUID bit whereas the 
> current version, 2.3.6, enables CLFLUSH iff SSE2 is enabled.  Qemu 0.9.0 
> has CLFLUSH.  Andi, do you happen to know of any specific simulators 
> which are problematic?  I would assume any recent version of SimNow is 
> up to date.

I don't know of any specific ones that lack CLFLUSH, although Bochs
definitely had similar problems in the past.

-Andi
