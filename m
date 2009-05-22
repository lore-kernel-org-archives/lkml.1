Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbZEVP0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbZEVP0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbZEVP0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:26:17 -0400
Received: from mail-px0-f103.google.com ([209.85.216.103]:46715 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbZEVP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NnmLvc6+cd3yBzDyggb1YJp1delEg0uG7iIYBXKshmn+g77ZsqyowxnNu8YfejZG2n
         8r3O3p5mzrRSgbvaWHmyPX0LzCAHOCouzNPF+CKily9W7PU9EWgtQjtTlU4dULJuZpaN
         CeooMXWXAQK0FwWqMwzmASbSY1npKce5nQGmo=
MIME-Version: 1.0
In-Reply-To: <20090522161016.36ef6f15@lxorguk.ukuu.org.uk>
References: <1243004787-5362-1-git-send-email-tom.leiming@gmail.com>
	 <20090522161016.36ef6f15@lxorguk.ukuu.org.uk>
Date: Fri, 22 May 2009 23:26:16 +0800
Message-ID: <d82e647a0905220826p378f6bb4vac9150343b5c3622@mail.gmail.com>
Subject: Re: [PATCH] driver core : fix request_firmware_nowait
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Fri, 22 May 2009 23:06:27 +0800
> tom.leiming@gmail.com wrote:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> request_firmware_nowait declares it can be called in non-sleep contexts,
>> but kthead_run which is called by request_firmware_nowait may sleep.
>
> Does anyone actually need to call it in a non-sleeping context or can the
> documentation simply be fixed instead to avoid all the extra complexity ?
>

It seems no one calls it in a non-sleeping context now, but we can provide it
without much extra complexity, IMHO.  Also someone has complained it :

      http://marc.info/?t=124022846400003&r=1&w=2

-- 
Lei Ming
