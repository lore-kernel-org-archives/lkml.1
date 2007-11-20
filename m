Return-Path: <linux-kernel-owner+w=401wt.eu-S1762461AbXKTUX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762461AbXKTUX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759344AbXKTUXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:23:45 -0500
Received: from mx1.suse.de ([195.135.220.2]:50021 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758359AbXKTUXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:23:44 -0500
From: Danny Kukawka <dkukawka@suse.de>
To: Michael E Brown <Michael_E_Brown@dell.com>
Subject: Re: [PATCH][RFC] drivers/firmware/dcdbas: rework to get uevents
Date: Tue, 20 Nov 2007 21:23:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Frank Seidel <fseidel@suse.de>, linux-kernel@vger.kernel.org,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Warzecha <Douglas_Warzecha@dell.com>
References: <200711141932.03190.fseidel@suse.de> <200711161153.54423.fseidel@suse.de> <20071120193515.GA16195@humbolt.us.dell.com>
In-Reply-To: <20071120193515.GA16195@humbolt.us.dell.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711202123.36112.dkukawka@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 20. November 2007, Michael E Brown wrote:
> On Fri, Nov 16, 2007 at 11:53:53AM +0100, Frank Seidel wrote:
> > On Mittwoch 14 November 2007 19:32:01, you (Frank Seidel) wrote:
> > > Hi,
> > >
> > > this is a small trivial rework of the dcdbas driver so
> > > HAL can get uevents when platform devices are added or removed.
> >
> > Sorry for the noise! In the meantime i realized (thanks to a nice
> > colleague) this isn't really necessary anymore since patch
> > 43cc71eed1250755986da4c0f9898f9a635cb3bf is in mainline.
> >
> > If you'd anyway to add this patch i gues this is a better version
> > of it.
>
> Frank, Danny,
>
> Can you possibly explain a bit why this patch is necessary? Danny, does
> this fix the module load problems that you had detailed in your earlier
> email?
>
> If this is still necessary, then either Doug or Matt can queue it up for
> next kernel release.

AFAIK the patch Frank posted isn't needed anymore since this is commited to 
mainline: 43cc71eed1250755986da4c0f9898f9a635cb3bf 

Danny
-- 
Danny Kukawka
dkukawka@suse.de
Mobile Devices
SUSE LINUX a Novell Business
Maxfeldstr. 5, D-90409 Nuernberg, Germany
SUSE LINUX Products GmbH, Nuernberg; GF: Markus Rex, HRB 16746 (AG Nuernberg)
