Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYEORh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYEORh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYEORhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:37:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYEORhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:37:15 -0400
Message-ID: <482C744C.3050308@redhat.com>
Date: Thu, 15 May 2008 13:35:08 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Weird Xorg radeon mirroring with linux-next-20080515
References: <g0hflu$b4q$1@ger.gmane.org>
In-Reply-To: <g0hflu$b4q$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> Hi,
> 
> When using the radeon xorg driver with linux-next-20080515 there is a
> strange mirroring/stretching effect in the bottom eighth of the screen. The
> problem seems to have started sometime between linux-next-20080513 and 
> linux-next-20080515.
> 
> (Do you always have to have done bisection before reporting regressions?)
> 

NO!

But in this case, given that the reproducer is simple and deterministic, but 
you're not sure which subsystem is the cause, bisection is well-suited to the 
task.  You might be able to shave a few steps off by targeting dri-related 
commits, but that's just a guess.

-- Chris
