Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZCYTXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZCYTXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZCYTXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:23:40 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:54465 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZCYTXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:23:40 -0400
Date: Wed, 25 Mar 2009 20:23:35 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: align data size for host which only supports
 power-of-2 block
Message-ID: <20090325202335.42abc221@mjolnir.ossman.eu>
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA03C5D7C5@chinexm1.ad.analog.com>
References: <1236309321-23955-1-git-send-email-cooloney@kernel.org>
	<20090314213038.4d14526e@mjolnir.ossman.eu>
	<0F1B54C89D5F954D8535DB252AF412FA03C5D7C5@chinexm1.ad.analog.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 11:22:25 +0800
"Cai, Cliff" <Cliff.Cai@analog.com> wrote:

> >
> >This patch seems premature as there is no associated 
> >modification of any of the host drivers.
> 
> The SDH on Blackfin BF54x/BF51x only supports power-of-2 block
> transfer,we will soon
> Send the sdh driver to mainline as well.
> 

Ok. Looking forward to it. :)

> >Padding to a power of two size can also mean a rather large 
> >padding. We might need to check the host data limits after 
> >doing the adjustment.
> 
> Yes,but it's the higher level driver's job. 
> 

mmc_align_data_size() shouldn't be adjusting the size to something it
can easily determine that it's invalid.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
