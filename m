Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbYCNVIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbYCNVIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYCNVHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:07:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43981 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759258AbYCNVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:07:50 -0400
Date: Fri, 14 Mar 2008 14:06:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205479398.3215.284.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803141400170.28115@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
  <1205463842.3215.188.camel@ymzhang> <1205465447.3215.195.camel@ymzhang> 
 <Pine.LNX.4.64.0803132333020.24204@schroedinger.engr.sgi.com>
 <1205479398.3215.284.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Zhang, Yanmin wrote:

> On my 8-core stoakley, there is no such regression. Below data is after 
> testing.

I was looking for the details on two slab caches. The comparison of the 
details statistics is likely very interesting because we will be able to
see how the doubling of processor counts affects the internal behavior of 
slub.

