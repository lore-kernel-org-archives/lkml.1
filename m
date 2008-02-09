Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYBIVqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYBIVqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 16:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYBIVqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 16:46:38 -0500
Received: from relay2.sgi.com ([192.48.171.30]:59784 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752667AbYBIVqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 16:46:37 -0500
Date: Sat, 9 Feb 2008 13:46:34 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Roland Dreier <rdreier@cisco.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: [patch 0/6] MMU Notifiers V6
In-Reply-To: <20080209075556.63062452@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
 <20080208234302.GH26564@sgi.com> <20080208155641.2258ad2c.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
 <adaprv70yyt.fsf@cisco.com> <Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>
 <adalk5v0yi6.fsf@cisco.com> <Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>
 <20080209012446.GB7051@v2.random> <Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>
 <20080209015659.GC7051@v2.random> <Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>
 <20080209075556.63062452@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Rik van Riel wrote:

> PG_mlock is on the way and can easily be reused for this, too.

Note that a pinned page is different from an mlocked page. A mlocked page 
can be moved through page migration and/or memory hotplug. A pinned page 
must make both fail.

