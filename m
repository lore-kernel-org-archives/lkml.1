Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0BVMjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:39:39 -0500
Received: from swm.pp.se ([212.247.200.143]:50938 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab0BVMji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:39:38 -0500
Date: Mon, 22 Feb 2010 13:39:37 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-kernel@vger.kernel.org
Subject: Re: disk/crypto performance regression 2.6.31 -> 2.6.32 (mmap
 problem?)
In-Reply-To: <alpine.DEB.1.10.1002191729220.28940@uplift.swm.pp.se>
Message-ID: <alpine.DEB.1.10.1002221337170.28940@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1002191729220.28940@uplift.swm.pp.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010, Mikael Abrahamsson wrote:

> I have a system with 8 gigs of ram, c2d 2.4GHz and md 
> raid6->crypto->lvm/lv->xfs that I've had for quite a while. It used to be 
> raid5, but with 2.6.32 I was able to restripe it into a raid6.

This is not a 2.6.32 regression, the behaviour is similar in 2.6.31 I have 
verified during the weekend.

It seems iostat isn't really able to see exactly where the bottleneck is, 
and my guess right now is that it's indeed the md raid6 layer that is 
causing my performance problems, even though it doesn't look like it in 
iostat.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
