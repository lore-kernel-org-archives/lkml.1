Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbYEVEZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbYEVEZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765325AbYEVEX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:23:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49263 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764768AbYEVEX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:23:57 -0400
Message-ID: <4834F4DC.3040009@cs.helsinki.fi>
Date: Thu, 22 May 2008 07:21:48 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, dhowells@redhat.com
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI> <20080521234555.GB32707@linux-sh.org> <4834F2E2.3070806@cs.helsinki.fi> <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>> That's probably due to the fact that we use PageSlab for all pages with SLUB
>> and for bigblock pages in SLOB with this patch. Christoph, Matt, any
>> suggestions how to fix the PageSlab check in nommu btw?
> 
> I already posted a patch and commented numerous times. What else needs 
> to be said? SLUB only uses PageSlab for kmalloc <=4kb.

(I missed your patch, btw.)

For SLOB, we will never use ksize() as it doesn't set PageSlab. Is that 
not a problem?

		Pekka
