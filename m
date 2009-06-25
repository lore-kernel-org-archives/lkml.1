Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZFYRVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZFYRVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZFYRVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:21:05 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48413 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZFYRVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:21:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tPzWLyxwg6F84hCQROLpsj+HiseQC7LWRbe8LsmiWDX1NPwCBK/1xMWPY6e8y75K0M
         uwPyNXUbkjfI3zKgOZPcRUCNDlRK0IoWCpRuMcUASvgbAKaikIHeOc5A5KsOvw5r6QeY
         6+4vksUkvC4dnUN6fdiLuQhiKfCndGBc5QI5Y=
Message-ID: <4A43B1FC.7060609@tuffmail.co.uk>
Date: Thu, 25 Jun 2009 18:21:00 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: 2.6.30-rc1: touchpad disabled on hibernation
References: <4A438BA7.9010800@tuffmail.co.uk> <8db1092f0906251016l5ac85bfdpbac841b939cfac2a@mail.gmail.com>
In-Reply-To: <8db1092f0906251016l5ac85bfdpbac841b939cfac2a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/6/25 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
>   
>> The synaptics touchpad on my EeePC 701 dies on hibernation.  2.6.30 was
>> fine, and it doesn't happen on suspend to ram either.  There are no
>> obvious error messages, but maybe this boot message is relevant:
>>
>> Platform driver 'i8042' needs updating, please use dev_pm_ops
>>
>>     
>
> Similar on s2disk, HP/Compaq notebook. Try reload psmouse module. I
> reported it, but nobody answer.
>   
That works, thanks.

Alan

