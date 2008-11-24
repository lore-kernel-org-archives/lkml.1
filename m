Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYKXQLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYKXQLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYKXQLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:11:10 -0500
Received: from smtp-out.google.com ([216.239.45.13]:56773 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbYKXQLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:11:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=MmvuRWmlq8Kojzxv+rOobvRTpttAAZ9Ep8LrqKgbX5eEknAr2xt+u84B699zkecHK
	/cSvAgwlTbB+lW2HItE+A==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0811221645250.707@p34.internal.lan>
References: <alpine.DEB.1.10.0811221645250.707@p34.internal.lan>
Date: Mon, 24 Nov 2008 08:11:05 -0800
Message-ID: <da824cf30811240811l416431f5kf56e0925f561342@mail.gmail.com>
Subject: Re: Question regarding SAS controllers.
From: Grant Grundler <grundler@google.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Alan Piszcz <ap@solarrain.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 1:46 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Do any SAS controllers exist that are not RAID?
>
> Or to put it another way, if one wants to use SAS disks for example and NOT
> export them as JBOD or use them as RAID, is there a normal controller?

Besides mptsas, there is mvsas (Marvell 6480 chip , IIRC).

> Back in the days of regular SCSI you had SCSI controllers and SCSI raid
> controllers, when searching for SAS controllers now, all that comes up is
> hundreds of SAS-Raid controllers.

Because lots of the windows server users demand HW RAID?
And it's a "value add"; vendors can charge more money for the RAID cards.

grant
