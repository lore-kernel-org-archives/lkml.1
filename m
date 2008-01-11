Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbYAKGZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbYAKGZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 01:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbYAKGZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 01:25:05 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:52840 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759119AbYAKGZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:25:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q/LkHjR4ecWtmtgZmZ6kePhFfvG3utsx58LJz+1FQe97DDngQnOT4zOfx4ynz0vlMfu4vaAnrqPaIpxRYl4WJn18/+TKrEmFlWHQa+fGqUvay7LAgkovTEMigFvujsxwb/yVxqJbIbsFlFps6Od9ly8zcQRqXJcCU9WhxhqxMxQ=
Message-ID: <8bd0f97a0801102225q69b56703gaffbc85a31390b4e@mail.gmail.com>
Date: Fri, 11 Jan 2008 01:25:01 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Cc: "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "Cai, Cliff" <Cliff.Cai@analog.com>, linux-kernel@vger.kernel.org
In-Reply-To: <386072610801102217u1739d7d7v497e73a38aa876c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	 <0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
	 <20080109082325.212ec90d@poseidon.drzeus.cx>
	 <386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
	 <20080110095428.3b93fd18@poseidon.drzeus.cx>
	 <386072610801100122n52339488ke2b8724c390be765@mail.gmail.com>
	 <20080110125748.416ad0c5@poseidon.drzeus.cx>
	 <386072610801102217u1739d7d7v497e73a38aa876c2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 1:17 AM, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> On Jan 10, 2008 7:57 PM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > On Thu, 10 Jan 2008 17:22:55 +0800
> > "Bryan Wu" <cooloney.lkml@gmail.com> wrote:
> >
> > >
> > > At page 4-3 of  ADSP-BF54x Blackfin(R) Processor Peripheral Hardware
> > > Reference, there is a table which guide us the SDH controller does not
> > > support 4-bit mode MMC card. Please found the table picture in the
> > > attachment or get the document at:
> > > http://www.analog.com/UploadedFiles/Associated_Docs/61460151169789ADSP_BF54x_Blackfin_Processor_Peripheral_Hardware_Reference.pdf
> > >
> >
> > Ok, but this just means the controller wasn't designed with 4-bit MMC in mind. As several other "SD-only" controller have been tested with modern MMC cards without a problem, this is not sufficient to explain any problem.
> >
>
> This should be some HW design issue and BF54x including SDH controller
> is in mass production.
> There is no chance to change the silicon, we just wanna use software
> driver to workaround this issue.
> So Mike's patch is here.
>
> > >
> > > Thanks, actually we are not yet convinced  by our hardware designer
> > > why BF54x SDH does not support 4-bit MMC.
> > >
> >
> > Please keep me informed on how it progresses. I'd like an at least plausible explanation, preferably also some empirical data, before I'm ready to accept Mike's patch.
> >
>
> We were told this is an hardware design issue, so please help us to
> workaround it in software side with Mike's patch.
> And how do you think my suggestion to Mike's patch,
> #define MMC_CAP_4_BIT_DATA ( MMC_CAP_SD_4_BIT_DATA | MMC_CAP_MMC_4_BIT_DATA)
> Then no need to change other MMC host drivers

i can send an updated patch as needed.  i think Bryan's suggestion
here is a good one.
-mike
