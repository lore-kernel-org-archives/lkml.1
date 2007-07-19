Return-Path: <linux-kernel-owner+w=401wt.eu-S965300AbXGSPXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300AbXGSPXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965199AbXGSPWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:22:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:19451 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965188AbXGSPWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SExWS3E7vKCLxmi/Num02F18NQZdxgryFfxRoXsZCcOhu2okBGL3FginIR5zAcJiuD/ypDCbi+Kok54nqbq1TBQ6SOvjjqhIlGp75bQ5Yp1+dbAeDzSJH2omX3v83NGLaRIeKQW8tDdVnRJJC6EA9oWSH3VRh+00v46HRu9CitE=
Message-ID: <d120d5000707190822v44ca6fb0lefcc5302d3f7b8de@mail.gmail.com>
Date: Thu, 19 Jul 2007 11:22:38 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH for review] [12/48] x86_64: use the global PIT lock
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20070719134841.5677614E6E@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070719348.540885000@suse.de>
	 <20070719134841.5677614E6E@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On 7/19/07, Andi Kleen <ak@suse.de> wrote:
>
> From: Thomas Gleixner <tglx@linutronix.de>
>
> Replace the pcspkr private PIT lock by the global PIT lock to serialize the
> PIT access all over the place.
>

Like I said before I'd be more happy if spinlock was attached to a
platform device that pcspkr binds to so the arch code would control
wehther we use a private spinlock or a global one (I sent a patch to
that effect earlier). However I am OK with Thomas's patch as well.

-- 
Dmitry
