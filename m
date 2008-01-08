Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYAHVoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYAHVoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYAHVoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:44:12 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:51470 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYAHVoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:44:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bIrGAaDNQmipmpC067OKky5HwJkLS3wr6Bn5lPU4W3+d8oP/1ybJ75SfewveAtCczYEZOhBI1p7hMjhE/qyZCn8oYAk9GwnyUsQiteL30Jhn7F5G1bpCbejD9N5I3Ix8GtUGfTJNqXjgZvvrVPCYIsTo16ZD0kVK+K1IWu1oEew=
Message-ID: <8bd0f97a0801081344i55100937qc1ad178dd94c358b@mail.gmail.com>
Date: Tue, 8 Jan 2008 16:44:08 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080108214946.03018d95@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801081329.39611.vapier.adi@gmail.com>
	 <20080108202157.0b8d3393@poseidon.drzeus.cx>
	 <200801081440.49683.vapier.adi@gmail.com>
	 <20080108214946.03018d95@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 3:49 PM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Tue, 8 Jan 2008 14:40:49 -0500
> Mike Frysinger <vapier.adi@gmail.com> wrote:
> > i dont understand what's confusing.  the Blackfin on chip host controller only
> > supports 1-bit MMC, but it supports 4-bit SD/SDIO.  this is a fact.  while it
> > may be a stupid decision, it is what it is, and i need the framework made
> > more flexible in order to get the Blackfin driver merged cleanly.  we do
> > software for hardware, we dont do hardware.
>
> Well, since I've seen no _hardware_ differences between 4-bit MMC and 4-bit SD, "support" in this case must me "vendor will guarantee it works". And that is not the kind of "support" that needs a distinction in the code.

regardless of where the limitation is, the change is necessary.
however you wish to classify the issue, it doesnt matter to me.  the
Blackfin controller needs to declare the following capabilities:
 - 1-bit MMC
 - 1-bit SD / 4-bit SD
 - 1-bit SDIO / 4-bit SDIO
the existing framework is not flexible enough to account for this,
thus the patch posted.

> So, again, if you feel that there is a hardware difference between 4-bit MMC and 4-bit SD then please elaborate as it is my understanding that they are identical.

you may be 100% correct, i have no idea, i'm not really familiar with
MMC/SD/SDIO at all.
-mike
