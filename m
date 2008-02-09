Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYBIBY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYBIBY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 20:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYBIBYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 20:24:50 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:46214
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbYBIBYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 20:24:49 -0500
Date: Sat, 9 Feb 2008 02:24:46 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Roland Dreier <rdreier@cisco.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
       avi@qumranet.com, linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, Rik van Riel <riel@redhat.com>
Subject: Re: [ofa-general] Re: [patch 0/6] MMU Notifiers V6
Message-ID: <20080209012446.GB7051@v2.random>
References: <Pine.LNX.4.64.0802081528070.4036@schroedinger.engr.sgi.com> <20080208233636.GG26564@sgi.com> <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com> <20080208234302.GH26564@sgi.com> <20080208155641.2258ad2c.akpm@linux-foundation.org> <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com> <adaprv70yyt.fsf@cisco.com> <Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com> <adalk5v0yi6.fsf@cisco.com> <Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 04:36:16PM -0800, Christoph Lameter wrote:
> On Fri, 8 Feb 2008, Roland Dreier wrote:
> 
> > That would of course work -- dumb adapters would just always fail,
> > which might be inefficient.
> 
> Hmmmm.. that means we need something that actually pins pages for good so 
> that the VM can avoid reclaiming it and so that page migration can avoid 
> trying to migrate them. Something like yet another page flag.

What's wrong with pinning with the page count like now? Dumb adapters
would simply not register themself in the mmu notifier list no?

> 
> Ccing Rik.
