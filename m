Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbXGVJAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbXGVJAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbXGVJAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:00:40 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:5674 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760801AbXGVJAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:00:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gunDGJdmQSy4fgfRBK2t6Pp1LSCq7NJEl36pOyxBLLHAoYXWb1TU52gpZRf+Ml0rKDN9BkiHA5v34gwsHZnV7PlcnvLNepWYxPvZLno7vohuKhHbwSfLXsADPpPuRkqbtOeWygXo2r2BGDhvn7hBbfZLX9xm3VPS8pcMHYeJQng=
Message-ID: <84144f020707220200od2c6418k4d72996e2e66df3d@mail.gmail.com>
Date: Sun, 22 Jul 2007 12:00:37 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>, "Jens Axboe" <axboe@kernel.dk>,
       "Andrew Morton" <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
       drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
In-Reply-To: <20070722060925.GD18326@mail.linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721203819.GA10706@mail.linbit.com>
	 <p73hcnxuxji.fsf@bingen.suse.de>
	 <20070722060925.GD18326@mail.linbit.com>
X-Google-Sender-Auth: e1ddc02a772aaf82
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On 7/22/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> there is just one logical piece, the drbd module...
> it is all in its own subdirectory.
> it does not really touch anything else.
> I don't think it is feasible to split it further.

I don't know your code at all but the diffstat suggests that "lru
cache", "worker", "receiver", and "bitmap" could possibly be made
independent patches with all Kconfig and Makefile changes appearing as
a final separate patch (so it's git-bisectable).

This is 17 KLOC of new code. You really want to make it easy to review
if you're serious about getting it merged.

                                   Pekka
