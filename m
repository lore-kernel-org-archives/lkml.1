Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbXH3NzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbXH3NzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbXH3Nys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:54:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:62595 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887AbXH3Nyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SpNELESd/puH31vf5cVeG9niayGHzSGLVrWI3I/x8L7H8dWsWA1SbZwu8seNSTaOUKN5yxRZmNflH0nu0B2Z4zvdxrRa5IeBXf6Z2hX6HXHwQuy/Sz26K2YinAVuvO3wKUO/4AaAy+lKm/pIURoNWz/DpSlYPMtF7PEQJqC9UdM=
Message-ID: <9a8748490708300654l3e2acbbdkc2cbf01838a2fffa@mail.gmail.com>
Date: Thu, 30 Aug 2007 15:54:45 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: bamakhrama@gmail.com
Subject: Re: Average number of instructions per line of kernel code
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <40378e40708300648i4f016906v60f821bf182a5633@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40378e40708300600h5837d46ci5266b8ae62bbd46e@mail.gmail.com>
	 <9a8748490708300631o285fd31ch462199ec9535c6c2@mail.gmail.com>
	 <40378e40708300648i4f016906v60f821bf182a5633@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/2007, Mohamed Bamakhrama <bamakhrama@gmail.com> wrote:
> On 8/30/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > On 30/08/2007, Mohamed Bamakhrama <bamakhrama@gmail.com> wrote:
> > > Hi all,
> > > I have a question regarding the average number of assembly
> > > instructions per line of kernel code. I know that this is a difficult
> > > question since it depends on many factors such as the instruction set
> > > architecture, compiler used, optimizations used, type of code, coding
> > > style, etc...
> > > I would like to know a rough estimate for such a quantity for the
> > > kernel 2.4/2.6 code running on MIPS32 architecture.
> > > My estimate is between 5-10 instructions. I googled for such a thing
> > > but couldn't find any useful papers/resources.
> > >
> >
> > Why don't you simply count the number of non-blank non-comment lines
> > in the source files that you are building, build the kernel and then
> > count the number of instructions in the resulting binary ?
>
> Hi,
> I agree with you but is there any way to include ALL the drivers in
> the kernel tree in building the image? Otherwise, I will be counting
> un-used lines.
>
make allyesconfig
make


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
