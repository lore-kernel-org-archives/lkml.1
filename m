Return-Path: <linux-kernel-owner+w=401wt.eu-S936073AbYEUTNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936073AbYEUTNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYEUTNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:13:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43362 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYEUTNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:13:46 -0400
Message-ID: <483473EA.40901@cs.helsinki.fi>
Date: Wed, 21 May 2008 22:11:38 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, clameter@sgi.com, lethal@linux-sh.org,
       dhowells@redhat.com
Subject: Re: [RFC/PATCH 3/3] SLOB: make ksize() more strict for page	allocator
 pass-through
References: <Pine.LNX.4.64.0805212125570.22291@sbz-30.cs.Helsinki.FI> <1211396840.18026.276.camel@calx>
In-Reply-To: <1211396840.18026.276.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> We already know users (ie nommu memory usage reporting) are abusing this
> interface. Making them blow up is unnecessary. Just give them wrong
> answers. Issuing a warning might be a good idea for debugging.

But kobjsize() never calls ksize() with SLOB as it doesn't set PageSlab. 
Or are you talking about something else here?

Matt Mackall wrote:
> Second, I'd prefer to keep this sort of debugging code out of SLOB.
> SLUB is much better suited to debugging allocator abuse.

Fair enough. I'll drop the patch.
