Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbZL2UEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbZL2UEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZL2UEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:04:11 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36286 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbZL2UEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:04:08 -0500
Date: Tue, 29 Dec 2009 21:04:05 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/scsi : Correct the size argument to kmalloc
In-Reply-To: <200912292102.43373.eike-kernel@sf-tec.de>
Message-ID: <Pine.LNX.4.64.0912292103180.4001@ask.diku.dk>
References: <Pine.LNX.4.64.0912292015420.4001@ask.diku.dk>
 <200912292102.43373.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Dec 2009, Rolf Eike Beer wrote:

> Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > In each case, the destination of the allocation has type struct **, so the
> > elements of the array should have pointer type, not structure type.
> 
> Maybe they should even by kcalloc'ed?

I thought about that, but in response to another patch someone seemed to 
think kcalloc was not very useful.  But I can certainly change it in this 
case.

julia
