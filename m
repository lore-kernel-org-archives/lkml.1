Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbYBIANZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbYBIANZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbYBIANO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:13:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150AbYBIANM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:13:12 -0500
Date: Fri, 8 Feb 2008 16:12:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, andrea@qumranet.com, avi@qumranet.com,
       izike@qumranet.com, kvm-devel@lists.sourceforge.net,
       a.p.zijlstra@chello.nl, steiner@sgi.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       general@lists.openfabrics.org
Subject: Re: [patch 0/6] MMU Notifiers V6
Message-Id: <20080208161248.506556b0.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
References: <20080208220616.089936205@sgi.com>
	<20080208142315.7fe4b95e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802081528070.4036@schroedinger.engr.sgi.com>
	<20080208233636.GG26564@sgi.com>
	<Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
	<20080208234302.GH26564@sgi.com>
	<20080208155641.2258ad2c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 16:05:00 -0800 (PST) Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 8 Feb 2008, Andrew Morton wrote:
> 
> > You took it correctly, and I didn't understand the answer ;)
> 
> We have done several rounds of discussion on linux-kernel about this so 
> far and the IB folks have not shown up to join in. I have tried to make 
> this as general as possible.

infiniband would appear to be the major present in-kernel client of this new
interface.  So as a part of proving its usefulness, correctness, etc we
should surely work on converting infiniband to use it, and prove its
goodness.

Quite possibly none of the infiniband developers even know about it..
