Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZBFAIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZBFAIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZBFAIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:08:35 -0500
Received: from gw.goop.org ([64.81.55.164]:47566 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZBFAIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:08:34 -0500
Message-ID: <498B7F7F.3090701@goop.org>
Date: Thu, 05 Feb 2009 16:08:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hugh Dickins <hugh@veritas.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu> <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu> <Pine.LNX.4.64.0902051921150.30938@blonde.anvils> <498B4F1F.5070306@goop.org> <Pine.LNX.4.64.0902052046240.18431@blonde.anvils> <498B54A0.7040005@goop.org> <20090205215050.GB28097@elte.hu> <498B6325.1040401@goop.org> <20090205234241.GA14203@elte.hu>
In-Reply-To: <20090205234241.GA14203@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> just the act of using PAE was measured to cause multi-percent slowdown in 
> fork() and exec() latencies, etc. The pagetables are twice as large so is 
> that really surprising?
>   

Is there a similar slowdown running the CPU in 32 vs 64 bit mode?  Or 
does having more/wider registers mitigate it?

    J
