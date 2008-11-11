Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYKKTdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYKKTdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYKKTdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:33:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbYKKTdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:33:08 -0500
Date: Tue, 11 Nov 2008 11:32:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: avi@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kvm@vger.kernel.org, aarcange@redhat.com, chrisw@redhat.com
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux
Message-Id: <20081111113247.c2b0f1ac.akpm@linux-foundation.org>
In-Reply-To: <4919DA7F.5090106@redhat.com>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
	<20081111103051.979aea57.akpm@linux-foundation.org>
	<4919D370.7080301@redhat.com>
	<20081111111110.decc0f06.akpm@linux-foundation.org>
	<4919DA7F.5090106@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 21:18:23 +0200
Izik Eidus <ieidus@redhat.com> wrote:

> > hm.
> >
> > There has been the occasional discussion about idenfifying all-zeroes
> > pages and scavenging them, repointing them at the zero page.  Could
> > this infrastructure be used for that?  (And how much would we gain from
> > it?)
> >
> > [I'm looking for reasons why this is more than a muck-up-the-vm-for-kvm
> > thing here ;) ]

^^ this?

> KSM is separate driver , it doesn't change anything in the VM but adding 
> two helper functions.

What, you mean I should actually read the code?   Oh well, OK.

