Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZAMDVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZAMDVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZAMDVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:21:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48138 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZAMDVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:21:37 -0500
Date: Tue, 13 Jan 2009 04:36:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>, andi@firstfloor.org,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090113033608.GN23848@one.firstfloor.org>
References: <20090112213539.GA10720@gambetta> <496BCA21.2010709@sgi.com> <20090112235156.GC10720@gambetta> <496BD8FB.1050101@sgi.com> <20090113000112.GA10368@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113000112.GA10368@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > (And was it determined yet, that a cacheline has to be tossed around as 
> > well?)
> 
> No, that assertion of Andi is wrong.

For the IPI you always have to toss one cache line around to pass
the information.

Anyways the padding is just to avoid false sharing.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
