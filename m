Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbZKYSD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbZKYSD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZKYSD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:03:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59566 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZKYSD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:03:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=u5A9YGwZ89Oq3pAMaVa1Al+9mFW/Bxmlx9w4Jju+flo3h4P3eu4mPb4WVZDawqWzDJ
         +HK9lHWOH56OJmjXmQMAbjBoaDiclDuuCAFJNPX4EotXLmd3hGJEFBxdqCT6wTcm/s0+
         nmC75h9ko20dqbaJaTHUmUFWuaDoplGhPKQqM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 86/86] libata: add private driver field to struct ata_device
Date: Wed, 25 Nov 2009 19:02:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125171248.5446.22482.sendpatchset@localhost> <20091125175650.64de8a10@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125175650.64de8a10@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911251902.45049.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:56:50 pm Alan Cox wrote:
> On Wed, 25 Nov 2009 18:12:48 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] libata: add private driver field to struct ata_device
> > 
> > This brings struct ata_device in-line with struct ata_{port,host}.
> 
> Do we need it for anything yet - whoever first needs it can add it,
> otherwise its just waste.

There is a new driver using it (to be posted later) and it makes libata API
more coherent for driver developers..

--
Bartlomiej Zolnierkiewicz
