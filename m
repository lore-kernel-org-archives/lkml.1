Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656Ab0AZGnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0AZGnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244Ab0AZGnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:43:11 -0500
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:36443 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751903Ab0AZGnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:43:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NUsrNToDdZx/6+MwlHo4F9Lkpweu8T/d7xUepk4JBIPNYS8o1mKp1nkYCCotz6Y4mR2pnQbEDX7rCp2CJZtPurBRYua1rX2G95sWq5EXtUI2XwgtrDAPklAjWPP3XCcvlO6AZkchIgPXi4ony2/TzYImO3LXLLU5ep2zzMPRZXw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: R2dVkUUVM1kL68lLnQff9YUUjOzDMMVq2jG17icaS0.mKIaxbEodOCdSprXrfnwtoDRAcm8lKimUwQep7Q1VdHvHYl0OmLAH6tdbVEnJMcRit0zKqFOcVm1JBySamIBJENGhSBpkyJlgdl_fHjBgdRxzv8tcfJlS.nkvkFERo9ElMc198qmIN9..VsduVWK75rpCJ5qcSV3jg_qU_uY7TC52tM7pOquJXyS67TDiAkHTrfuYVFUAAN1ctrzN6QQJ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 2/4] of/gpio: Add support for two-stage registration for the of_gpio_chips
Date: Mon, 25 Jan 2010 22:36:15 -0800
User-Agent: KMail/1.9.10
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20100125180957.GA5380@oksana.dev.rtsoft.ru> <20100125181103.GB13805@oksana.dev.rtsoft.ru>
In-Reply-To: <20100125181103.GB13805@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201001252236.16141.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Anton Vorontsov wrote:
> With this patch there are two ways to register OF GPIO controllers:
> 
> 1. Allocating the of_gpio_chip structure and passing the
>    &of_gc->gc pointer to the gpiochip_add. (Can use container_of
>    to convert the gpio_chip to the of_gpio_chip.)
> 
> 2. Allocating and registering the gpio_chip structure separately
>    from the of_gpio_chip. (Since two allocations are separate,
>    container_of won't work.)
> 
> As time goes by we'll kill the first option.

Why have two options, instead of just the first/simpler one??

