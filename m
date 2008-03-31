Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYCaLV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYCaLV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYCaLVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:21:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:44508 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYCaLVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:21:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nzmdNFUm06o1qFCBPTlqSJWEfaEpzVBoKH5QNTlLZJFDQBLvAIhIH7SUka7DLcYjXls7c8nCGN/YTYy0t3kI8/uRlgpSoVede14c7DgWmcGf/xFhZazjirzcVn1sdJeFXhsTpl+FkTX1FUeTM+qeYD/Zl0zYm2I4ZzyMFnXvcUA=
Message-ID: <21d7e9970803310421k67f1a697s8ffb5a4eef71c605@mail.gmail.com>
Date: Mon, 31 Mar 2008 21:21:19 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86: create array based interface to change page attribute
Cc: "Dave Airlie" <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, arjan@linux.intel.com,
       thomas@tungstengraphics.com
In-Reply-To: <87myof8ief.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com>
	 <87myof8ief.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 5:25 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Dave Airlie <airlied@redhat.com> writes:
>  >
>  > +#define CPA_FLUSHTLB 1
>  > +#define CPA_ARRAY 2
>
>  I don't think CPA_ARRAY should be a separate case. Rather single
>  page flushing should be an array with only a single entry. pageattr
>  is already very complex, no need to make add more special cases.

I thought about this but the current interface takes a start address
and number of pages from that point to cpa,
the array interface takes an array of page sized pages.

I don't really think we need to generate an array in the first case
with all the pages in it..

Dave.
