Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYCVCwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYCVCwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYCVCwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:52:14 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:37756 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYCVCwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:52:13 -0400
Date: Sat, 22 Mar 2008 03:52:01 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Alasdair G Kergon <agk@redhat.com>
cc: Chr <chunkeey@web.de>, Milan Broz <mbroz@redhat.com>,
       David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, dm-devel@redhat.com, dm-crypt@saout.de,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120
 seconds
In-Reply-To: <20080317173609.GD29322@agk.fab.redhat.com>
Message-ID: <alpine.DEB.1.00.0803220348520.17137@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803150108.04008.chunkeey@web.de> <200803151432.11125.chunkeey@web.de> <200803152234.53199.chunkeey@web.de> <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de>
 <20080317173609.GD29322@agk.fab.redhat.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Alasdair G Kergon wrote:
> From: Milan Broz <mbroz@redhat.com>
>
> Fix regression in dm-crypt introduced in commit
> 3a7f6c990ad04e6f576a159876c602d14d6f7fef
> (dm crypt: use async crypto).

I finally got around to test this - and yes, 2.6.25-rc6 with this patch 
applied make the hangs go away. There are other problems now[0], but they 
don't seem to be related, AFAICT.

Thank you!
Christian.

[0] http://lkml.org/lkml/2008/3/21/408
-- 
BOFH excuse #197:

I'm sorry a pentium won't do, you need an SGI to connect with us.
