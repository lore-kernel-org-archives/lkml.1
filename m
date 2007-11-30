Return-Path: <linux-kernel-owner+w=401wt.eu-S1764113AbXK3Tdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764113AbXK3Tdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXK3Tdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:33:31 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46818 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755222AbXK3Tdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:33:31 -0500
Date: Fri, 30 Nov 2007 11:33:30 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 03/10] percpu: Make the asm-generic/percpu.h more "generic"
In-Reply-To: <20071130184952.GC9928@elte.hu>
Message-ID: <Pine.LNX.4.64.0711301117590.2129@schroedinger.engr.sgi.com>
References: <20071128210926.008783214@sgi.com> <20071128211526.640694725@sgi.com>
 <20071130111000.GA32431@elte.hu> <Pine.LNX.4.64.0711300908320.32071@schroedinger.engr.sgi.com>
 <20071130171419.GA18808@elte.hu> <Pine.LNX.4.64.0711300915460.32253@schroedinger.engr.sgi.com>
 <20071130175825.GA19571@elte.hu> <20071130181206.GA1586@elte.hu>
 <Pine.LNX.4.64.0711301033580.1806@schroedinger.engr.sgi.com>
 <20071130184952.GC9928@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ahh this is a UP configuration! For that case we do not rebase the percpu 
area to address 0. And all the reports of success are until now for 
SMP/NUMA. Switching SMP on makes your config boot fine.

I thought I left UP handling unchanged. There must be some subtle 
change. Looking for it now.


