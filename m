Return-Path: <linux-kernel-owner+w=401wt.eu-S1946048AbXEBBJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946048AbXEBBJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 21:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946103AbXEBBJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 21:09:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49457 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946048AbXEBBJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 21:09:35 -0400
Date: Tue, 1 May 2007 18:09:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Nate Diller <nate.diller@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zero_user_page uses in fs/buffer.c and fs/libfs.c
In-Reply-To: <20070501172643.270bb061.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705011807550.28210@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com>
 <a781481a0704292353v34ea217fpbbf732465dd652e8@mail.gmail.com>
 <Pine.LNX.4.64.0704300000430.3147@schroedinger.engr.sgi.com>
 <20070501172643.270bb061.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Andrew Morton wrote:

> As Satyam said, this will sometimes cause us to map and unmap the page
> twice, and to run flush_dcache_page() twice.  In not-terribly-uncommon
> circumstances in very frequently called functions.
> 
> Doesn't seem worth it to me.

Ok but we have that code three times. Should I add a variant of 
zero_user_page that zeroes everything but the section specified?

zero_user_page_allbut() ?

