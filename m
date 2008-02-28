Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbYB1Mxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbYB1Mxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 07:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYB1Mxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 07:53:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:58319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbYB1Mxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:53:30 -0500
Message-ID: <47C6AF31.9080604@suse.de>
Date: Thu, 28 Feb 2008 13:55:13 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc][patch] x86-64 new smp_call_function design
References: <20080227124217.GA1340@wotan.suse.de> <20080227132713.GA13681@elte.hu> <20080227135041.GC1340@wotan.suse.de> <20080227150210.GA21610@elte.hu> <20080227221407.GA26067@wotan.suse.de> <20080228084558.GA32631@elte.hu>
In-Reply-To: <20080228084558.GA32631@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> The vector duplication is really ugly and feels wrong.
>> Why?
> 
> it's ~0.5% of our irq vector space? :-)

Since there per CPU vectors vectors are not really a precious resource
anymore.

-Andi
