Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0CDLLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 06:11:10 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:44625 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0CDLLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 06:11:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ckoVVTEBlrZhD5B7pFn0Gx0IDSsiW/pK4vceQEhhHrzahBOOAZxu4MzXXM0kRWAvgU
         LMYqe2thHU74v/ZhB1dqiWUQipHTyFhX/RPPzYOOMlpttHWOOSdRgUwYfwkpdNvI+ml8
         tleSnlVXtNjo9xOv19WLrntAzZgUkluguU3UQ=
MIME-Version: 1.0
In-Reply-To: <201003040125.30091.rjw@sisk.pl>
References: <201003040125.30091.rjw@sisk.pl>
Date: Thu, 4 Mar 2010 12:11:06 +0100
Message-ID: <b170af451003040311g3cea44caj1cd0e23e55814696@mail.gmail.com>
Subject: Re: [PATCH] ACPI / PM: Move ACPI video resume to a PM notifier
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/4 Rafael J. Wysocki <rjw@sisk.pl>:
> There is a problem with the ACPI video resume routine that it's
> executed before the GPU that may be accessed by it.  To fix this
> issue, move the ACPI video resume to a power management notifier,
> so that it's executed after resuming all devices, including the GPU.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

Tested-by: Rafał Miłecki <zajec5@gmail.com>

It partially fixes bugzilla bug #15096 and it first needed step to fix
it completely.

Can we send this to stable for .32 and .33?

-- 
Rafał
