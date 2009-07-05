Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZGEKJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZGEKJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 06:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZGEKJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 06:09:35 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39044 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZGEKJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 06:09:34 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jul 2009 06:09:34 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uloPYRqrrEzwOfWe3wTsiQgi2EqU5OAC804gImUebFVL0RYu3hwna2ZdFaShnvnqvy
         a0GyccjAFSa10wMzmF8ka3LS4z1y86HsMtLYu1HZqddztRAwroel28gL+hcwnRBGeU5o
         Tox1wY+v/PAevOCn7iHC4w3y7951zWpjTfZzg=
MIME-Version: 1.0
In-Reply-To: <20090629131440.GN5139@amd.com>
References: <6278d2220906280405y731f7f2l65472ec5f62dbc83@mail.gmail.com>
	 <20090629131440.GN5139@amd.com>
Date: Sun, 5 Jul 2009 11:03:40 +0100
Message-ID: <6278d2220907050303y5442cb05h6098a9c7a6beeb6e@mail.gmail.com>
Subject: Re: [2.6.30-rc1] lockdep false positive in DMA debug API...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 2:14 PM, Joerg Roedel<joerg.roedel@amd.com> wrote:
> On Sun, Jun 28, 2009 at 12:05:17PM +0100, Daniel J Blueman wrote:
>> With 2.6.30-rc1, I'm seeing the lockdep validator spinning it's wheels
>> [1] (also already seen [2]) on the DMA debug interface, with the
>> hashed locks.
>
> If you don't actually mean 2.6.3_1_-rc1 this is a known bug which was
> fixed for 2.6.30-final.

It's in 2.6.30 proper, but is now fixed in 2.6.31-rc and 2.6.30.1 by
"dma-debug: Put all hash-chain locks into the same lock class":
http://groups.google.com/group/linux.kernel/browse_thread/thread/73ae3a0fc04185c8#

Thanks anyway!
  Daniel
-- 
Daniel J Blueman
