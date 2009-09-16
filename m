Return-Path: <linux-kernel-owner+w=401wt.eu-S933565AbZIPVET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbZIPVET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933511AbZIPVEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:04:12 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:44925 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760083AbZIPVEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:04:11 -0400
X-IronPort-AV: E=Sophos;i="4.44,400,1249272000"; 
   d="scan'208";a="4517741"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] input/keyboard: add ADP5588 QWERTY I2C Keyboard Input device driver
Date: Wed, 16 Sep 2009 17:07:34 -0400
User-Agent: KMail/1.9.5
CC: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       "Hennerich, Michael" <michael.hennerich@analog.com>,
       "Bryan Wu" <cooloney@kernel.org>
References: <1252966719-27557-1-git-send-email-vapier@gentoo.org> <20090915062050.GB10232@core.coreip.homeip.net> <8bd0f97a0909150419p1048bfe9j243fa30a0581b198@mail.gmail.com>
In-Reply-To: <8bd0f97a0909150419p1048bfe9j243fa30a0581b198@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <200909161707.34804.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 16 Sep 2009 21:03:19.0669 (UTC) FILETIME=[1E5A5A50:01CA3711]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15 Sep 2009 07:19, Mike Frysinger pondered:
> On Tue, Sep 15, 2009 at 02:20, Dmitry Torokhov wrote:
> > On Mon, Sep 14, 2009 at 06:18:39PM -0400, Mike Frysinger wrote:
> >> +static int __devexit adp5588_remove(struct i2c_client *client)
> >> +{
> >> +     struct adp5588_kpad *kpad = dev_get_drvdata(&client->dev);
> >> +
> >> +     adp5588_write(client, CFG, 0);
> >> +     free_irq(client->irq, kpad);
> >
> > cancel_work_sync() is missing. Could you try the updated version below?
> 
> i dont think i have any adp5588 hardware.  Robin: do we have any in
> Norwood?  otherwise, it'll have to wait for Michael to get back to
> double check.

I think Michael has the only hardware at the moment.

He will be back on Monday.
