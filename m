Return-Path: <linux-kernel-owner+w=401wt.eu-S1751737AbZJXTjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbZJXTjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 15:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZJXTjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 15:39:35 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57982 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZJXTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 15:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Kokn7jBq5fhebUG1K3juzdJYBxT7qTBigqy+cb8qPtJWhh9MtZ9yszAZIJZHxfqqAX
         VAKbjkkaIbAMC/toUCFyX1EtTjuMdjYqyL+KBJ/JdlOCvjNqoOpPgg1bUEAJfxvRMTSw
         9iGff6BhCbubOKSCpRAYpiK2uxAociykVR/NI=
Message-ID: <4AE357F6.7030600@googlemail.com>
Date: Sat, 24 Oct 2009 21:39:34 +0200
From: Gonsolo <gonsolo@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Gonsolo <gonsolo@gmail.com>, mchehab@infradead.org, pboettcher@dibcom.fr,
       linux-media@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: DVB-T dib0700 one minute hang when resuming
References: <4AE32EF2.2040508@googlemail.com> <200910242014.18785.oliver@neukum.org>
In-Reply-To: <200910242014.18785.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.10.2009 20:14, schrieb Oliver Neukum:
> Am Samstag, 24. Oktober 2009 18:44:34 schrieb Gonsolo:
>> Hi!
>>
>> The following script fixes an annoying 62 second hang when resuming
>> while my Nova-T stick is connected to my notebook.
>>
> Do you have any idea why it doesn't find its firmware?

Don't know. Maybe it's because it is not included in initrd or user 
space is still not available when resuming. In the first case it is a 
Ubuntu Kernel bug, in the second case the driver has to be fixed by 
using request_firmware_nowait. But please notice that I am absolutely 
not qualified to answer this question. I was hoping to get an answer on 
that issue since this is the last annoying bug that keeps my 
Ubuntu/Debian/Gnome/GNU/Linux distribution from being perfect. :)

g

