Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXH3NbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXH3NbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbXH3NbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:31:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:52156 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbXH3NbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tbf/1dqadHJfjHu2WgCOHDNLGiBeBUtJDhp2bNz7IV7H21AafjbaK8rSlgTLKFCbtGAnzwZxBGHQyNeGhLHIvWQt7d/rh3c9cexxbwa+c1RLyKeJf1SeDKUV7/+tvKOaFo7eh640/ZTZrOs5umhAhDK39wTGWYNEfW+DgmW1ZU0=
Message-ID: <9a8748490708300631o285fd31ch462199ec9535c6c2@mail.gmail.com>
Date: Thu, 30 Aug 2007 15:31:12 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: bamakhrama@gmail.com
Subject: Re: Average number of instructions per line of kernel code
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <40378e40708300600h5837d46ci5266b8ae62bbd46e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40378e40708300600h5837d46ci5266b8ae62bbd46e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/2007, Mohamed Bamakhrama <bamakhrama@gmail.com> wrote:
> Hi all,
> I have a question regarding the average number of assembly
> instructions per line of kernel code. I know that this is a difficult
> question since it depends on many factors such as the instruction set
> architecture, compiler used, optimizations used, type of code, coding
> style, etc...
> I would like to know a rough estimate for such a quantity for the
> kernel 2.4/2.6 code running on MIPS32 architecture.
> My estimate is between 5-10 instructions. I googled for such a thing
> but couldn't find any useful papers/resources.
>

Why don't you simply count the number of non-blank non-comment lines
in the source files that you are building, build the kernel and then
count the number of instructions in the resulting binary ?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
