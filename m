Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbYGSJUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbYGSJUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 05:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYGSJT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 05:19:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:7705 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYGSJT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 05:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uVYVT8/8MPVqvuhsPZlD0ncrMR7GDlPMih34fLOcvD3kkyPy9JchbBpKGijQR0I8rU
         IiWw79vV7VyBT3iPctF2BoXZyPmGdjCyyeGo6ETFrJWa7UBC4YvB9q29+4I9hhPyxkfk
         8H3owXvV7TFgyRiwTpC+fZerniwo34ASBV2ek=
Message-ID: <86802c440807190219m4cd71274qaea4975a9add15d4@mail.gmail.com>
Date: Sat, 19 Jul 2008 02:19:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joerg Roedel" <joro@8bytes.org>
Subject: Re: [PATCH] x86: introduce x86_ops
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080719091612.GB13662@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807190207.26077.yhlu.kernel@gmail.com>
	 <20080719091612.GB13662@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 2:16 AM, Joerg Roedel <joro@8bytes.org> wrote:
> Hi Yinghai,
>
> can you please write a short commit message explaining the benefit? Also
> x86_ops sounds a bit too generic for some architecture specific
> initialization function pointers imho.

put all over visws_quirks in one structs, and may extend that to othat subarch

YH
