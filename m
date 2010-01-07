Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268Ab0AGQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0AGQdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953Ab0AGQds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:33:48 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:46488 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab0AGQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:33:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KfdxjICekzxuKWTykCLObQIdecVMOXk2SuS/ixaUPEvuQcW582ufk9yKtPLZyRb3X7
         2jihYtyEp2/YciB+7FIxF6bNk/6bao6HkmTHyJq8XPtLABQAEwD0VL0EPX0BGz/eQNAI
         PyAltC+qrNqNSJ+lSDOaMi96qMBTCG2wWg+MQ=
Message-ID: <4B460D07.2000301@gmail.com>
Date: Thu, 07 Jan 2010 08:34:15 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] sys_paccept: disable paccept() causes my macbook	pro
 to  have an annoying whining sound
References: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com> <873a2ixmwy.fsf@basil.nowhere.org> <4B460132.3010706@gmail.com> <20100107160246.GB16076@basil.fritz.box>
In-Reply-To: <20100107160246.GB16076@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/10 08:02, Andi Kleen wrote:
>> As for the power management
>> I didn't think so.. sounds more
>> like vibration of a solder joint/capacitor
>
> Typically those are caused by power management -- cpu going in/out
> sleep states.
>
> You can check by e.g. limiting your CPU to C1 with
> processor.max_cstate=1
>
> -Andi

alright.
one thing that I want to try also
is doing a git reset --hard
to the commit that the bisect showed me
just to see if this is the trouble spot
(if not, then I'll go ahead with another
bisect).

Justin P. Mattock
