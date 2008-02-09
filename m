Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbYBIM6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbYBIM6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYBIM6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:58:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbYBIM6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:58:20 -0500
Date: Sat, 9 Feb 2008 07:55:56 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Roland Dreier <rdreier@cisco.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: [patch 0/6] MMU Notifiers V6
Message-ID: <20080209075556.63062452@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
	<20080208234302.GH26564@sgi.com>
	<20080208155641.2258ad2c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
	<adaprv70yyt.fsf@cisco.com>
	<Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>
	<adalk5v0yi6.fsf@cisco.com>
	<Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>
	<20080209012446.GB7051@v2.random>
	<Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>
	<20080209015659.GC7051@v2.random>
	<Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 18:16:16 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:
> On Sat, 9 Feb 2008, Andrea Arcangeli wrote:
> 
> > The VM shouldn't break if try_to_unmap doesn't actually make the page
> > freeable for whatever reason. Permanent pins shouldn't happen anyway,
> 
> VM is livelocking if too many page are pinned that way right now.

> Rik has a patchset under development that addresses issues like this

PG_mlock is on the way and can easily be reused for this, too.

-- 
All rights reversed.
