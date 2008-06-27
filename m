Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbYF0SY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbYF0SY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbYF0SYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:24:48 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:30362 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752587AbYF0SYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:24:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NQpK3YyoVBxPmcSPts7okVkrlQxPMTqN6OYW5tXHtKCxMzHcSC8ssm1rjyy+aLiPICDqNrODIWnZnC1avWbfHQyQwjAAd+L+nWhnC40pBDAG9z71zxJQUdKxsV5eHYemFl93stueTvPabDTutNwEozrxU5w6nRiEhB13sXiyqY4=  ;
X-YMail-OSG: rJm1vFgVM1lRQbmXha9oMCVpyd_GVUFNRhnWGdwAjYGrfB6tWQlQEhngyZUteXouiwNUazM4tnpwXKZREiXqMPuGtott9mk1HbwQKwD8ydxRroOT7a2Wo7S1Kxw3JEnHbcg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for AVR32 users
Date: Fri, 27 Jun 2008 11:24:42 -0700
User-Agent: KMail/1.9.9
Cc: Dan Williams <dan.j.williams@intel.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       "Nelson, Shannon" <shannon.nelson@intel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com> <200806270937.21850.david-b@pacbell.net> <20080627174441.GB4306@cs181140183.pp.htv.fi>
In-Reply-To: <20080627174441.GB4306@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806271124.42783.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2008, Adrian Bunk wrote:
> The only effect of the HAVE_DMA_ENGINE would be to not show an empty 
> kconfig menu.

Well, no.  It would also make the network layer memcpy "acceleration"
option unavailable when there was no underlying engine ... similarly
with other pointless "we don't have that subsystem here" options.

Plus it would help ensure that the arch dependencies are comprehenible,
unlike that highmem thing.

