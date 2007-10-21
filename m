Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbXJUJlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbXJUJlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbXJUJk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:40:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:45799 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXJUJkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bMr3HFH2pDt87GjolbZp+/OiIBxJZFWTaDiAQUDJQUrvDKODmZ9uglWoPSi7qYlg0bzht21Tf1hDekLwcCA95AM4xAntopuFckoFQOWq4dwvjfuAdCR65/wEabKMJXYsabJlQ7JYfelXqIZ7HQHbX4tawHAALt/k1ow60eEfEPA=
Message-ID: <ef242d300710210240y5a5cc412vb1a8606d02bd5108@mail.gmail.com>
Date: Sun, 21 Oct 2007 17:40:55 +0800
From: "Nai XIA" <nelson.xia@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: The meaning of first_logical_block in do_mpage_readpage
In-Reply-To: <ef242d300710210103x1a8ec38ev7b0d1e93a5739ecb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ef242d300710210103x1a8ec38ev7b0d1e93a5739ecb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, I think I've found the point.
first_logical_block is passed out in a "for" loop in "mpage_readpages"
and passed again to the next "do_mpage_readpage".

Sorry for the haste asking.


On 10/21/07, Nai XIA <nelson.xia@gmail.com> wrote:
> hi, it may be a stupid question, but I am not quite clear about what
> "first_logical_block" is used for as one of parameters of
> "do_mpage_readpage".
>
> I searched all the source code and I found that "first_logical_block"
> always equals zero when passed to "do_mpage_readpage" and is  used
> only in scope of "do_mpage_readpage".
>
> This makes me wonder about:
> 1. when should "first_logical_block" passed as non-zero values ?
> 2. why "first_logical_block" is one of args of "do_mpage_readpage"
> instead of being a local variable of it ? ( it seems that no one uses
> "first_logical_block" outside  "do_mpage_readpage")
>
> Anyone can help me out .
> Thanks in advance!
>
