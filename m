Return-Path: <linux-kernel-owner+w=401wt.eu-S967801AbXILNsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967801AbXILNsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764810AbXILNr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:47:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45088 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbXILNrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:47:55 -0400
Date: Wed, 12 Sep 2007 15:47:23 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: "Venkat Subbiah" <venkats@cranite.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: irq load balancing
Message-ID: <20070912154723.3d870787@laptopd505.fenrus.org>
In-Reply-To: <3641F7C576757E49AE23AD0D820D72C4232DEA@mailnode1.cranite.com>
References: <3641F7C576757E49AE23AD0D820D72C4232DEA@mailnode1.cranite.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 16:18:15 -0700
"Venkat Subbiah" <venkats@cranite.com> wrote:

> Most of the load in my system is triggered by a single ethernet IRQ.
> Essentially the IRQ schedules a tasklet and most of the work is done
> in the taskelet which is scheduled in the IRQ. From what I read looks
> like the tasklet would be executed on the same CPU on which it was
> scheduled. So this means even in an SMP system it will be one
> processor which is overloaded.
> 
> So will using the user space IRQ loadbalancer really help? What I am
> doubtful about is that the user space load balance comes along and
> changes the affinity once in a while. But really what I need is every
> interrupt to go to a different CPU in a round robin fashion.

if you round robin network interrupts your performance will be really
really bad....
