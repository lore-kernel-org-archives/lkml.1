Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbXH3Nsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbXH3Nsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbXH3Nsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:48:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:4281 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbXH3Nsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cyUdk3x819m5NTw88WR1j3Ox6g7bNSXwjt66rsu4IM2wj62XEsaZ5GNrJyxXTBIh/cyTXy6KpinwnZd5LYf5uWeiR0uCv5u315pj39iW7PqnUWCYXjtsHTV7f7L8GU3VfjQnBLxwFBI7rK2aBCRx79Ajp6XSYm8qSVelbQfrrho=
Message-ID: <40378e40708300648i4f016906v60f821bf182a5633@mail.gmail.com>
Date: Thu, 30 Aug 2007 15:48:35 +0200
From: "Mohamed Bamakhrama" <bamakhrama@gmail.com>
Reply-To: bamakhrama@gmail.com
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: Average number of instructions per line of kernel code
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490708300631o285fd31ch462199ec9535c6c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40378e40708300600h5837d46ci5266b8ae62bbd46e@mail.gmail.com>
	 <9a8748490708300631o285fd31ch462199ec9535c6c2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 30/08/2007, Mohamed Bamakhrama <bamakhrama@gmail.com> wrote:
> > Hi all,
> > I have a question regarding the average number of assembly
> > instructions per line of kernel code. I know that this is a difficult
> > question since it depends on many factors such as the instruction set
> > architecture, compiler used, optimizations used, type of code, coding
> > style, etc...
> > I would like to know a rough estimate for such a quantity for the
> > kernel 2.4/2.6 code running on MIPS32 architecture.
> > My estimate is between 5-10 instructions. I googled for such a thing
> > but couldn't find any useful papers/resources.
> >
>
> Why don't you simply count the number of non-blank non-comment lines
> in the source files that you are building, build the kernel and then
> count the number of instructions in the resulting binary ?

Hi,
I agree with you but is there any way to include ALL the drivers in
the kernel tree in building the image? Otherwise, I will be counting
un-used lines.

-- 
Mohamed
