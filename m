Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZKJOd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZKJOd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZKJOd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:33:28 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:38505 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbZKJOd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=m9h/V53COcWq5gPUo1Q7eEt2NbrK7CTguSX8nyaX+jalnGnkTBhJ1r6M1bD9ef3Cn7
         J8SgGA9dP9Da7i5t3OiXQkMl52Om87pQOM1v6i7VFzDFerRl94Q0xIx/mFKFp7xe9XZR
         hEyNjjERzCu9P7yk25yxXF39qoPfdTDtgATeo=
MIME-Version: 1.0
In-Reply-To: <200911091358.03545.rusty@rustcorp.com.au>
References: <cover.1257602781.git.andre.goddard@gmail.com> 
	<643e6260a571b533d8985b377a82410aded4ddae.1257602781.git.andre.goddard@gmail.com> 
	<200911091358.03545.rusty@rustcorp.com.au>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Tue, 10 Nov 2009 12:33:13 -0200
Message-ID: <b8bf37780911100633t15be84b1m906e0d30a1269c68@mail.gmail.com>
Subject: Re: [PATCH v4 01/12] vsprintf: factorize "(null)" string
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 1:28 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Hi Andre,
>
> Consistently using <NULL> or (null) makes sense.  But I'm really missing your argument: is there some reason
> why normal string merging won't work?
>

Hi, Rusty!

    I agree that it works fine as well; the factorization only makes
explicit the fact that's a constant string, that's all.

Thank you,
André
