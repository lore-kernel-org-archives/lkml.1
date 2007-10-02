Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXJBFCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXJBFCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 01:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXJBFB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 01:01:56 -0400
Received: from usul.saidi.cx ([204.11.33.34]:57518 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750803AbXJBFB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 01:01:56 -0400
Message-ID: <4701D0BA.7080404@overt.org>
Date: Mon, 01 Oct 2007 22:01:46 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Pierre Ossman <drzeus@drzeus.cx>, sdhci-devel@list.drzeus.cx,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Disabler for Ricoh MMC controller
References: <4701B9AB.5070308@overt.org>  <1191300236.6310.60.camel@pasglop> <1191300334.6310.62.camel@pasglop>
In-Reply-To: <1191300334.6310.62.camel@pasglop>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Tue, 2007-10-02 at 14:44 +1000, Benjamin Herrenschmidt wrote:
>> On Mon, 2007-10-01 at 20:23 -0700, Philip Langdale wrote:
>>> Thanks to Matt Domsch and Rezwanul Kabir at Dell, we know how to disable the
>>> MMC controller on the multi-function Ricoh R5C832. The MMC controller needs
>>> to be disabled or it will steal MMC cards from the SD controller where they
>>> would otherwise be supported by the Linux SDHCI driver.
>> Why can't that be a quirk instead ?
> 
> That is, a global quirk or a quirk in the SDHCI driver...

Pierre doesn't want a quirk.

--phil
