Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445Ab0ASU1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0ASU1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340Ab0ASU1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:27:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58807 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab0ASU1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:27:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=kArSOFy9KngxaxNTEdKwU2ZOuOjDDXa4vTCTcwzSRhVEf6wyDboaI88uD4Yf5qVQVs
         LvEU1qDVOsSeqWtCBSG/OXc4T2hoGsQZDES6piGcB6yWpMdqbw/ljHX6mPoQto2ZjLwr
         DuwlDPArObhCqjH/asvrPJ4w4Im6DdBb/SntM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 25/64] ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()
Date: Tue, 19 Jan 2010 21:25:25 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: sshtylyov@ru.mvista.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100119.012526.203639880.davem@davemloft.net> <4B560B41.6080205@ru.mvista.com> <20100119.114816.78180589.davem@davemloft.net>
In-Reply-To: <20100119.114816.78180589.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001192125.25358.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 January 2010 08:48:16 pm David Miller wrote:
> From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Date: Tue, 19 Jan 2010 22:42:57 +0300
> 
> >   But shouldn't this just be merged to "ide: use standard timing for
> >   XFER_PIO_SLOW mode in ide_timing_compute()" since it's the patch that
> >   introduced that check?
> 
> It's fine either way.
> 
> I can break the ide-next-2.6 tree for everyone by rebasing it to
> unwind the 50 or so patches I applied from Bart yesterday to do this,
> but really is that pain worth it since right thing is there in the
> end?

Especially since the new patch is a pure documentation fix
in the practice (the old code happens to work fine anyway)..

--
Bartlomiej Zolnierkiewicz
