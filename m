Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbYF3TET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbYF3TET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbYF3TEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:04:09 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:15543 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756606AbYF3TEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:04:08 -0400
Date: Mon, 30 Jun 2008 23:04:07 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH] Add support for power_supply on tosa
Message-ID: <20080630190407.GA20400@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080620084917.GA20577@doriath.ww600.siemens.net> <20080623061943.GA6080@zarina> <20080624145107.GB31719@doriath.ww600.siemens.net> <20080630153232.GA4785@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080630153232.GA4785@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 07:32:32PM +0400, Dmitry Baryshkov wrote:
> On Tue, Jun 24, 2008 at 06:51:07PM +0400, Dmitry Baryshkov wrote:
> > Hi,
> > 
> > Please consider this updated version
> > 
> > From 314de1f70b669344f5b26ac2e4f8854a9024f17a Mon Sep 17 00:00:00 2001
> > From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > Date: Tue, 24 Jun 2008 18:50:18 +0400
> > Subject: [PATCH] Add support for power_supply on tosa
> > 
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > ---
> >  drivers/power/Kconfig        |    7 +
> >  drivers/power/Makefile       |    1 +
> >  drivers/power/tosa_battery.c |  487 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 495 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/power/tosa_battery.c
> > 
> 
> Any comments regarding this version?

Looks good to me (the race is still there, actually. but I'll fix the
comment :-). I'll apply this patch asap to get it build tested with
linux-next.

And again, much thanks for the patch!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
