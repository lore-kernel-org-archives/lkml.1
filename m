Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZCKQez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZCKQez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZCKQeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:34:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45417 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752202AbZCKQeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:34:46 -0400
Date: Wed, 11 Mar 2009 12:34:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 00/11] Hardware Breakpoint interfaces
In-Reply-To: <20090311121007.GC13835@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0903111232300.2692-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, K.Prasad wrote:

> The hardware breakpoint interfaces haven't been put under any CONFIG_
> till now, but I think we should bring them under a new config, say
> CONFIG_HW_BREAKPOINT. It would help create a dependancy for
> CONFIG_KSYM_TRACER too.

With these patches, ptrace is dependent on hw-breakpoint.  You can't 
disable CONFIG_HW_BREAKPOINT without breaking ptrace.

Alan Stern

