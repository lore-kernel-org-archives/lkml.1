Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZEPCrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZEPCrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 22:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZEPCrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 22:47:43 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:60939 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbZEPCrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 22:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SJ/IYlRJyoFSARTAzA6dXNZ6Q1Ik4KxLmKidBHCdFz74pCRnJIi7Ry3kxuhYLo3kKi
         X+mhLTZg2P1KggGVIuxd4O+Ps8Dqgxi/hbO2i73M7ZRPh2XWytOrntTL/DlIBYRjXBCK
         ykxXNFLgG+e7RdwUi1FIrWl8c5AwkhOWwNiVU=
MIME-Version: 1.0
In-Reply-To: <93655eb70905151938y558bf86flcfb7c6b6b2c171c6@mail.gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <5bdc1c8b0905151012x51c19b5cv639cadab1cee3849@mail.gmail.com>
	 <93655eb70905151024o634f8432j6c3db85df1f6ddfc@mail.gmail.com>
	 <5bdc1c8b0905151120p5aa58318t1765544fbbb695b2@mail.gmail.com>
	 <93655eb70905151938y558bf86flcfb7c6b6b2c171c6@mail.gmail.com>
Date: Fri, 15 May 2009 19:47:43 -0700
Message-ID: <5bdc1c8b0905151947j326d31d9k5c7b1074af2b0bf0@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Mark Knecht <markknecht@gmail.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 7:38 PM, Satish Eerpini <eerpini@gmail.com> wrote:
<SNIP>
> yeah I get similar numbers even in the absence of the desktop manager
> , when I tried to copy from  a virtual console.
> the stats look something like this :
<SNIP>
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
> SATA IDE Controller (rev 01)
<SNIP>

I googled on "82801GBM/GHM slow" and found a lot to read.

Is DMA for this drive enabled? It seems that some others didn't have
it enabled by default, or maybe at all. I didn't real the threads very
far.

hdparm -d1 /dev/sda

I think hdparm works for most SATA drivers. man sata to see the other
things you can check in terms of configuration.

Clearly, since you see the same thing in a console with X never having
been started says it's not a GUI issue.

Hope this helps,
Mark
