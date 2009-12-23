Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZLWTbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZLWTbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZLWTbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:31:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35510 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZLWTbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:31:13 -0500
Date: Wed, 23 Dec 2009 20:31:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Smith, GeoffX" <geoffx.smith@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michael Stone <michael@laptop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] prctl: return MCE process flags through pointer
Message-ID: <20091223193112.GN20539@basil.fritz.box>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com> <87hbricwz8.fsf@basil.nowhere.org> <20091222173424.980d5d33.akpm@linux-foundation.org> <20091223095223.GB20539@basil.fritz.box> <20091223021807.abbd993e.akpm@linux-foundation.org> <354B2877CF17F44BB3FA44EB4DB0E5470C91CE18A8@orsmsx510.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE18A8@orsmsx510.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, I wasn't aware of any published API, PR_MCE_KILL and KILL_GET just got accepted into mainline.  

An API is published as soon as the kernel including it is released.

> 
> I just noticed that these new options didn't follow the conventions of most prctl() options.  There is only one option newer than 2.3.48 that uses return-as-function-result, and that one is essentially a no-op.

We could have fixed it if you had mentioned that during code review before 2.6.32, but 
now it's too late (at least unless it would have been fundamentally broken or something like 
that, but I don't think that's the case)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
