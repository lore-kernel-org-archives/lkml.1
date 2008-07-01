Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYGALwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYGALwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYGALwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:52:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:5114 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYGALwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:52:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t3id2Aj26c/6m0OygVVGlRk59drJ9MfKWEpnaOqXJaxReqUUoyw4Qlo03Lss5EyGRG
         vXYwNeL9dRHAAZL1jKDTmQ7OmsDD14hLVnMtpD9G9OK9t5gOxlqIAx7Fim+ZWRnndc+l
         hk5vKVXxXSQoBUcuomuNFgT/Xv5uDO8d9aCGM=
Date: Tue, 1 Jul 2008 15:52:25 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH] Add support for power_supply on tosa
Message-ID: <20080701115225.GA7238@doriath.ww600.siemens.net>
References: <20080620084917.GA20577@doriath.ww600.siemens.net> <20080623061943.GA6080@zarina> <20080624145107.GB31719@doriath.ww600.siemens.net> <20080630153232.GA4785@doriath.ww600.siemens.net> <20080630190407.GA20400@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630190407.GA20400@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 11:04:07PM +0400, Anton Vorontsov wrote:
> On Mon, Jun 30, 2008 at 07:32:32PM +0400, Dmitry Baryshkov wrote:
> > On Tue, Jun 24, 2008 at 06:51:07PM +0400, Dmitry Baryshkov wrote:
> > > Hi,
> > > 
> > > Please consider this updated version
> > > 
> > > From 314de1f70b669344f5b26ac2e4f8854a9024f17a Mon Sep 17 00:00:00 2001
> > > From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > Date: Tue, 24 Jun 2008 18:50:18 +0400
> > > Subject: [PATCH] Add support for power_supply on tosa
> > > 
> > > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > ---
> > >  drivers/power/Kconfig        |    7 +
> > >  drivers/power/Makefile       |    1 +
> > >  drivers/power/tosa_battery.c |  487 ++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 495 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/power/tosa_battery.c
> > > 
> > 
> > Any comments regarding this version?
> 
> Looks good to me (the race is still there, actually. but I'll fix the
> comment :-). I'll apply this patch asap to get it build tested with
> linux-next.
> 
> And again, much thanks for the patch!

Thank you!

-- 
With best wishes
Dmitry

