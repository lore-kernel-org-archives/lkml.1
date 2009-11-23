Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZKWBSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZKWBSH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 20:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZKWBSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 20:18:06 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47368 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbZKWBSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 20:18:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bAq63kneaZTizRQDdR+/wL3/ONktw46H/ub5JtkXPpDrvHhQ+D5AMkR8R8VLdbCLw1
         WhmlxdOfpvLD7kPHboUr34GhLXRHag4wgPKi0Ph6FaVV8Qxk8mx1UbNpchcGNyEgmFTR
         ueHPuCMnJzMU69ZaAkMyk2jdkHKANRuMvubj4=
MIME-Version: 1.0
In-Reply-To: <m18wdypvjd.fsf@fess.ebiederm.org>
References: <86802c440911220226g21cc42bbmdc3ebe21d0f61943@mail.gmail.com>
	 <m18wdypvjd.fsf@fess.ebiederm.org>
Date: Sun, 22 Nov 2009 17:18:09 -0800
Message-ID: <86802c440911221718l541c0dq599f6a401fd03157@mail.gmail.com>
Subject: Re: [PATCH] x86: crash kernel reserve with reserve_early
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 4:56 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>
>> [PATCH] x86: crash kernel reserve with reserve_early
>>
>> use find_e820_area/reserve_early instead.
>> will get next good one automatically with alignment
>
> Semantically this is broken, as you are now ignoring a passed in
> base address if one is supplied.  What problem are you trying to fix?

avoid to use bootmem.

also simpify the code.

YH
