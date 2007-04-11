Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXDKTXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXDKTXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964976AbXDKTXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:23:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:32967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965158AbXDKTXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aO9KYTXVxPLbA3yDS/6DdiT9hOhmvwTyOJleqE0YR2WHQfMJ+k8da0am5or1g50CC9vxvdHXd5u3LZ4L238ASfouqzd1K0D9uxBB5wFuGX7JXlGqptz/xSSLzyTLyo4xjCZesedqEcvMED8YVprMvADQfjgicCC0GbJtgkprU1c=
Message-ID: <461D35A5.3010005@gmail.com>
Date: Wed, 11 Apr 2007 21:23:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Danny Kukawka <dkukawka@suse.de>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       corentincj@iksaif.net, sziwan@users.sourceforge.net
Subject: Re: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
References: <22473653910004885@karneval.cz> <461CE6AA.6050806@gmail.com> <200704112018.31026.dkukawka@suse.de> <200704112032.11772.dkukawka@suse.de>
In-Reply-To: <200704112032.11772.dkukawka@suse.de>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Danny Kukawka napsal(a):
> On Mittwoch, 11. April 2007, Danny Kukawka wrote:
>> Jiri Slaby wrote:
>>> Corentin CHARY napsal(a):
>>>> Le Wednesday 11 April 2007 11:33:48 Jiri Slaby, vous avez écrit :
>>>>> asus_acpi, support F2JE model
>>>> Just use the new asus-laptop driver =)
>>>> (see acpi4asus-0.40)
>>> code seems good, but this is not so good:
>>> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
>>> #warning "This module does not support 2.6.20 yet, wait for a new release
>>> #=)" endif
>>>
>>> When do you plan to support latest kernels and merge it to mainline?
>> This patch fixes acpi4asus-0.40 for me at least with 2.6.20 on a ASUS R1F.
> 
> Btw. looks as if a new version of the driver (v0.41) is already in the mm-tree.

Good to hear, I've got a look only to .21-rc6-mm1, where are no changes like
this (there is 0.30).

I'm satisfied, thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
