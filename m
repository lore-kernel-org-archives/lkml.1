Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYJBUXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYJBUXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 16:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYJBUW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 16:22:56 -0400
Received: from mx1.wp.pl ([212.77.101.5]:43283 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbYJBUWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 16:22:55 -0400
Date: Thu, 2 Oct 2008 22:22:38 +0200
From: Marek Szuba <scriptkiddie@wp.pl>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regular system 'hiccups' with 2.6.25+ on amd64 machines
Message-ID: <20081002222238.49142513@ifurita.akmm.lan>
In-Reply-To: <2c0942db0810011509j6c35911fh55c4e3178caf7f04@mail.gmail.com>
References: <20081001235106.57edede4@ifurita.akmm.lan>
	<2c0942db0810011509j6c35911fh55c4e3178caf7f04@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000006 [gVYl]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 15:09:40 -0700
"Ray Lee" <ray-lk@madrabbit.org> wrote:

> The group scheduler has (or at least had, prior to now) known fairness
> and interactivity issues. Please disable it and try again.
Your assumption was correct, disabling the group scheduler has fixed
all the problems (except for the fact that when xruns do occur the
values are still extremely large - but that's probably just version
incompatibility between ALSA drivers in the kernel and libasound). Of
course this suggests that the group scheduler is still borked, at least
on amd64.

Thanks for your help!

Best regards,
-- 
MS
