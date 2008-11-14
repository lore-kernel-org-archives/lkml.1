Return-Path: <linux-kernel-owner+w=401wt.eu-S1751349AbYKNJBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbYKNJBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYKNJBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:01:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:34718 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYKNJBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:01:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZgC1sATy7/XhMlqYoRLG0iDgKIBa6OPk071szFXP+vPrkuRmqIy6bztJpL0xBCar7q
         VAnND41EUe2NtvIDeHSNKElVSZ9ylinaU6egPx2MFRNQzCEYAaM84xstVP2e7Y8s3cQ6
         H7RF+xvVJPwCMbNszUWSdiaIkFDjcNQNrpMUM=
Message-ID: <4104961b0811140101u138b3947q174a5885bd9fafe6@mail.gmail.com>
Date: Fri, 14 Nov 2008 17:01:20 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Where is acpi_copy_wakeup_routine in lastest kernel?
In-Reply-To: <4104961b0811140044i7e57fedcw568ea1cd82f09167@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0811140044i7e57fedcw568ea1cd82f09167@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see this link told me what have been changed.

https://lists.linux-foundation.org/pipermail/linux-pm/2008-February/016569.html

So my question is mainly focusing on, since there is no definition of
acpi_copy_wakeup_routine, why there we still can see the declaration
of this routine?

Thanks.

Regards
Jason

On Fri, Nov 14, 2008 at 4:44 PM, jidong xiao <jidong.xiao@gmail.com> wrote:
> Hi,
>
> In kernels before 2.6.25 there is a function called
> acpi_copy_wakeup_routine, but this routine is disappear ever since
> 2.6.26.
>
> lfs:/usr/src/linux-2.6.25 # grep -r acpi_copy_wakeup_routine *
> arch/x86/kernel/acpi/sleep.c:extern unsigned long
> acpi_copy_wakeup_routine(unsigned long);
> arch/x86/kernel/acpi/sleep.c:   acpi_copy_wakeup_routine(acpi_wakeup_address);
> arch/x86/kernel/acpi/wakeup_32.S:# acpi_copy_wakeup_routine
> arch/x86/kernel/acpi/wakeup_32.S:ENTRY(acpi_copy_wakeup_routine)
> arch/x86/kernel/acpi/wakeup_64.S:# acpi_copy_wakeup_routine
> arch/x86/kernel/acpi/wakeup_64.S:ENTRY(acpi_copy_wakeup_routine)
>
> lfs:/usr/src/linux-2.6.26 # grep -r copy_wakeup_routine *
> arch/x86/kernel/acpi/sleep.h:extern unsigned long
> acpi_copy_wakeup_routine(unsigned long);
>
> It's so strange that the definition is no longer there while there is
> still a declaration. What's the story behind this?Thanks.
>
> Regards
> Jason
>
