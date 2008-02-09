Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYBIAga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYBIAga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbYBIAgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:36:21 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46629 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755014AbYBIAgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:36:20 -0500
Date: Fri, 8 Feb 2008 16:36:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Roland Dreier <rdreier@cisco.com>
cc: andrea@qumranet.com, a.p.zijlstra@chello.nl, izike@qumranet.com,
       steiner@sgi.com, linux-kernel@vger.kernel.org, avi@qumranet.com,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, Rik van Riel <riel@redhat.com>
Subject: Re: [ofa-general] Re: [patch 0/6] MMU Notifiers V6
In-Reply-To: <adalk5v0yi6.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>
References: <20080208220616.089936205@sgi.com> <20080208142315.7fe4b95e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802081528070.4036@schroedinger.engr.sgi.com>
 <20080208233636.GG26564@sgi.com> <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
 <20080208234302.GH26564@sgi.com> <20080208155641.2258ad2c.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
 <adaprv70yyt.fsf@cisco.com> <Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>
 <adalk5v0yi6.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Roland Dreier wrote:

> That would of course work -- dumb adapters would just always fail,
> which might be inefficient.

Hmmmm.. that means we need something that actually pins pages for good so 
that the VM can avoid reclaiming it and so that page migration can avoid 
trying to migrate them. Something like yet another page flag.

Ccing Rik.

