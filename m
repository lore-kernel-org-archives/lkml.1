Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYAJLCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYAJLCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYAJLCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:02:01 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46957 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYAJLCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:02:01 -0500
Date: Thu, 10 Jan 2008 13:01:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Fix x86 32 bit FRAME_POINTER chasing code
Message-ID: <20080110110115.GD28740@does.not.exist>
References: <20080109220421.630d3516@laptopd505.fenrus.org> <20080110065438.GA23022@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080110065438.GA23022@elte.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 07:54:38AM +0100, Ingo Molnar wrote:
>...
> it's a 2.6.24.1 candidate i believe. We trigger plenty of various 
> crashes during x86.git maintenance and others hit various crashes in 
> -mm, so by the time .1 is released we'll have it in .25 and can backport 
> it. Most folks/distros will update to 2.6.24.1 very quickly so there's 
> no risk of months loss of quality to kerneloops.org data either.
>...

-stable should not introduce additional regressions, and my personal 
impression is that it already introduces too many regressions.

Either this patch is considered both important and safe enough for 
getting into Linus' tree now or it's simply too late for 2.6.24*

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

