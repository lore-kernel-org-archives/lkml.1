Return-Path: <linux-kernel-owner+w=401wt.eu-S964780AbXCILwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbXCILwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932529AbXCILwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:52:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:38336 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbXCILwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=P78tF7smKxknEdUetpTaL5yOI9RG/2f0f8GuarJxxxcLaVY49fi9s+vRclwrUXLOCU4b5jSjI1PkRaCrMay43nkJFt3oTU0SzogiemrxNlTjVvXf+IcWrMyuXoW6tjj5CQply5cZTvpxHJhUFzDTNBseh+I/yejl+2CXz7T4bzU=
Message-ID: <84144f020703090352s3ecd8ab4pdde6f24f6cf7cc47@mail.gmail.com>
Date: Fri, 9 Mar 2007 13:52:00 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [PATCH 2/7] revoke: add f_light flag for struct file
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
In-Reply-To: <200703091213.35691.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI>
	 <200703091108.58371.dada1@cosmosbay.com>
	 <84144f020703090243j6fd49b5eoa23f4cc12866725a@mail.gmail.com>
	 <200703091213.35691.dada1@cosmosbay.com>
X-Google-Sender-Auth: 3160e98438f0f17f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Then just drop the fget_light() 'optimisation' and always take a reference
> (atomic on f_count) regardless of single-thread or not. Instead of dirtying
> f_light, just do the straightforward thing and be with it.

That's what I did first but akpm thought it was "unfortunate." Hmm.. ;-)
