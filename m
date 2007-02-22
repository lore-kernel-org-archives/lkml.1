Return-Path: <linux-kernel-owner+w=401wt.eu-S1750785AbXBVKtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750785AbXBVKtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXBVKtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:49:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:58327 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbXBVKtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:49:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=k2WJmf1v4lktZ4zzvBm6Vzw0bBGAonNCVgxYQxle5sD/9Jhq5P7qOorvAphcYFxPkVJGooIR0L5VWTjZ7NNQTUzr1MhxUXRO4wqLe78WdwH2Lb/XwjorT2c4asmi9hMVuoCxNP+sKQV0CG1zaRy1etpXL6VNNDQRNHqU9FR8AzA=
Message-ID: <84144f020702220249k37306252q627bf3ceb28e8b5d@mail.gmail.com>
Date: Thu, 22 Feb 2007 12:49:11 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: SLUB: The unqueued Slab allocator
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: e7a603a9940119bc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 2/22/07, Christoph Lameter <clameter@sgi.com> wrote:
> This is a new slab allocator which was motivated by the complexity of the
> existing code in mm/slab.c. It attempts to address a variety of concerns
> with the existing implementation.

So do you want to add a new allocator or replace slab?

On 2/22/07, Christoph Lameter <clameter@sgi.com> wrote:
> B. Storage overhead of object queues

Does this make sense for non-NUMA too? If not, can we disable the
queues for NUMA in current slab?

On 2/22/07, Christoph Lameter <clameter@sgi.com> wrote:
> C. SLAB metadata overhead

Can be done for the current slab code too, no?

                                                 Pekka
