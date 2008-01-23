Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbYAWOfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbYAWOfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYAWOfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:35:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:50396 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYAWOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:35:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IJqBOvcFdZVpUd6QHoeHGoth9BbPWMN21XV5puW3Dgv3s33Gra/48HKnwTnRHma2HKxqiscDjXtax3XFCpBKM8dtfYWbqJiD/gEa1xWu+LoEqMngTxTDR/skj7PacWICtQ69EKTgipyOyVuJHhLCClHmTsxwiT2Di3nzfWdt1gk=
Message-ID: <4cc25cb20801230634w2cab51c7w8d62d75ec982f132@mail.gmail.com>
Date: Wed, 23 Jan 2008 22:34:57 +0800
From: rmingming <mingming.nk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Is try_module_get buggy?
In-Reply-To: <200801171409.39389.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cc25cb20801112035x16c69a40rf3103a73b6cda107@mail.gmail.com>
	 <200801171409.39389.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi rminming,
>
> try_module_get is designed to ensure that you don't call a function inside a
> module without a reference.  Like any reference function, it cannot handle
> the case where the argument is invalid (or invalidated partway through the
> call).
>
> In this case, the module pointer is usually inside a registered structure.
> The pointer will be valid until the structure is unregistered, which the
> calling code presumably prevents while it's doing a lookup.
>
> Hope that clarifies,
> Rusty.
>

Hi Rusty,

Thank you so much!
I think you mean that this situation can really happen, because this
is a reference function, but it is so seldom, and the common result of
this situation is a kernel oops, it's not very important. Am I right?

Sorry about later reply, thanks again.
Best wishes,

rmingming
