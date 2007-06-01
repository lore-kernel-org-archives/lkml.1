Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXFAVYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXFAVYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760693AbXFAVYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:24:14 -0400
Received: from gw.goop.org ([64.81.55.164]:45506 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758505AbXFAVYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:24:13 -0400
Message-ID: <46608E76.9080109@goop.org>
Date: Fri, 01 Jun 2007 14:24:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC 0/4] CONFIG_STABLE to switch off development checks
References: <20070531002047.702473071@sgi.com> <46603371.50808@goop.org> <Pine.LNX.4.64.0706011126030.2284@schroedinger.engr.sgi.com> <46606C71.9010008@goop.org> <Pine.LNX.4.64.0706011357290.4664@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706011357290.4664@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>> I disagree.  There are plenty of boundary conditions where 0 is not
>> really a special case, and making it a special case just complicates
>> things.  I think at least some of the patches posted to silence this
>> warning have been generally negative for code quality.  If we were
>> seeing lots of zero-sized allocations then that might indicate something
>> is amiss, but it seems to me that there's just a scattered handful.
>>
>> I agree that it's always a useful debugging aid to make sure that
>> allocated regions are not over-run, but 0-sized allocations are not
>> special in this regard.
>>     
>
> Still insisting on it even after the discovery of the cpuset kmalloc(0) issue?
>   

Sure. That was a normal buffer-overrun bug. There's nothing special
about 0-sized allocations.

J
