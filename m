Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZKWXbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZKWXbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZKWXbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:31:44 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:62332 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbZKWXbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:31:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Sctd7wvVolXwU+xaCRTBLRzcLn4+UiuaVCyR3314Bff9QvStclG3vHw+wB1z6xYXBm
         8p61MljTvUAZfs6MsXFi/keCfs+yvQMOpRibA5pJfC2ef5anZrkNrC6q7Ht78DZ/A0/T
         r8SxzMhaJ2YejX/WD8u/Kik3jvoWboUC5g1wY=
Message-ID: <4B0B1B62.2030302@gmail.com>
Date: Mon, 23 Nov 2009 17:31:46 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Otavio Salvador <otavio@ossystems.com.br>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Vortex86SX: only works with irqpoll
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com> <20091123134002.bac1e664.akpm@linux-foundation.org>
In-Reply-To: <20091123134002.bac1e664.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 03:40 PM, Andrew Morton wrote:
> On Thu, 19 Nov 2009 19:11:49 -0200
> Otavio Salvador<otavio@ossystems.com.br>  wrote:
>
>>
>> I got this machine working booting it with "irqpoll" parameter however
>> it drops the performance a lot and I'd like to try to fix the root
>> problem of it.
>>
>> Without 'irqpoll' the disk and network adaptor doesn't work.
>>
>> ...
>>
>> [    0.000000] ACPI Error: A valid RSDP was not found (20090903/tbxfroot-219)
>
> No ACPI.
>
> Please raise a report against acpi_bios@kernel-bugs.osdl.org at
> bugzilla.kernel.org, thanks.
>

I believe that just means the machine doesn't support ACPI at all..
