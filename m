Return-Path: <linux-kernel-owner+w=401wt.eu-S937778AbYEUVQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937778AbYEUVQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937879AbYEUVPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:15:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51076 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937789AbYEUVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:15:11 -0400
Message-ID: <4834905E.9010802@cs.helsinki.fi>
Date: Thu, 22 May 2008 00:13:02 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, dhowells@redhat.com
Subject: Re: [RFC/PATCH 3/3] SLOB: make ksize() more strict for page allocator
 pass-through
References: <Pine.LNX.4.64.0805212125570.22291@sbz-30.cs.Helsinki.FI> <1211396840.18026.276.camel@calx> <483473EA.40901@cs.helsinki.fi> <Pine.LNX.4.64.0805211411050.17853@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805211411050.17853@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> I also would prefer to keep this out of SLUB. Set/Clear PageSlab dirties 
> the cacheline and it forces the unlining of kmalloc_large.

Hmm, well, that leaves ksize() open for more abuse. I guess we'll just 
have to live with that then.
