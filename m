Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYABTtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYABTtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYABTtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:49:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:11431 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbYABTtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=flwAYRpPWW1hNAZw7f+J4FXBvhGJyTBfiXbx249JiVR5bOzylVvXyyc4IPR+pSK8tHUU5fL2/pR06W81qxACykJPk69C5QDZcCm+zVpWjl1qUKD5jPj3bBjd6Cvk4pRoHiy/0u4E8xGsb92sLbWIQdrzlBBk3KOVY00wVThKdbQ=
Message-ID: <84144f020801021149g43c39306s8f1e854b48f36c59@mail.gmail.com>
Date: Wed, 2 Jan 2008 21:49:10 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
Cc: "Hugh Dickins" <hugh@veritas.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
X-Google-Sender-Auth: 69b57121692f2347
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Jan 2, 2008 9:35 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Actually, I'd much rather just do this instead (on top of your patch)
>
> It just creates a new CONFIG_SLABINFO that automatically has the right
> dependencies (ie depends on PROC being on, and either SLAB or SLUB), and
> then both SLAB and SLUB just have the exact same interfaces.
>
> Which means that SLOB could also trivially implement the same thing, with
> no new #ifdef'fery or other crud.
>
> It's totally untested, but looks fairly obvious.

Looks good to me. Thanks! :-)

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
