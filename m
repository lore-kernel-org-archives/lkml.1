Return-Path: <linux-kernel-owner+w=401wt.eu-S1765593AbYDPTXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765593AbYDPTXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYDPTWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:22:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47886 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764932AbYDPTWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=bYN1UX2aWfo1UjNu5++tpj4Jq3RfoVKP03G8907H8HsZf2p89FdgZttdLsYVfKwhWENaA9Af56suSkAfJ1hI1hidCU4zqhPUcT1crSUJf3FkNm9J/J4LLAk/ekKCIZ8v4ghVaSOvz8W2cVeFc8z14lRHrQtdUB01VuaNyrMaHXk=
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [GIT PATCH] rfkill support for r/w and r/o rfkill switches
Date: Wed, 16 Apr 2008 21:26:43 +0200
User-Agent: KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <20080416183705.GA16123@tuxdriver.com>
In-Reply-To: <20080416183705.GA16123@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804162126.43771.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, John W. Linville wrote:
> On Fri, Apr 11, 2008 at 05:37:16PM -0300, Henrique de Moraes Holschuh wrote:
> > 
> > This patch series (based on v2.6.25-rc8-mm2) has several improvements to
> > the rfkill class that I need for thinkpad-acpi, plus two fluff and
> > documentation fixes.
> 
> Who is handling these rfkill patches?  I think in the past they have
> gone through me, but some may have gone directly to Dave M.

Yes initial rfkill introduction went through wireless, but subsequent patches
seemed to have gone directly into net-2.6.
I must admit I am not sure what the correct flow for rkfill should be. :S

> If they are coming to me, please collect Ivo's ACKs and resend them
> to linux-wireless@vger.kernel.org with me CC'ed as well.

I am going to setup a rfkill git tree from where rfkill can be managed,
but I still had to look into the correct git tree to branch from.

We should sort out how the rfkill patch flow should go,
directly into net-2.6 or to wireless-2.6/wireless-testing
Although rfkill is a wireless tool, one could argue that linux-wireless
is mostly aimed at the 802.11 protocol, whereas rfkill applies to
irda and bluetooth as well.

Ivo
