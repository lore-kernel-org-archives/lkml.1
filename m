Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZCGUUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZCGUUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 15:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZCGUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 15:19:56 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:44652 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbZCGUTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 15:19:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rjdXFwUUeRU/r+xkQvQkiyFk6OgT0CBd4vWcDuSUJNucc/OmvcOTZhHuqtnKvraBU9
         +Wd/HsvkErvIATufz5B9BoJo3xNpAEyl0tNpuC/ZxP+USKv0IGP+L/e+87/JUTqMHkRO
         2peCePpkzSkfmmsii/FMqrLUvTw/IPvm+hRQA=
MIME-Version: 1.0
In-Reply-To: <20090307154424.GA3909@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org>
	 <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru>
	 <20090307150640.GA3516@srcf.ucam.org>
	 <200903071839.16508.arvidjaar@mail.ru>
	 <20090307154424.GA3909@srcf.ucam.org>
Date: Sat, 7 Mar 2009 20:19:51 +0000
Message-ID: <15e53e180903071219q4ed318edt2fa8f492426c0ab6@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
From: Richard Hughes <hughsient@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hal@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 7, 2009 at 3:44 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sat, Mar 07, 2009 at 06:38:53PM +0300, Andrey Borzenkov wrote:
>
>> - patch toshiba_acpi to return KEY_SUSPEND/KEY_HIBERNATE instead of
>> KEY_SLEEP/KEY_SUSPEND. This depends on commit
>> 6932b918e05b06165ed3457a9f3aa279099a7cbd in linux-next.
>>
>> - patch HAL to recognize KEY_HIBERNATE and return "suspend" for
>> KEY_SUSPEND; right now it is:
>>
>>         [KEY_SLEEP] = "sleep",
>>         [KEY_SUSPEND] = "hibernate",
>
> Ugh. Why are we changing this? The semantics were pretty clear before.
> The KEY_SUSPEND to hibernate mapping was decided years ago, and it's
> clearly an incompatible change as far as userspace goes.

See my mails to linux-acpi. Hibernate = sleep to disk, suspend = sleep
to ram, and sleep = sleep type not indicated or unknown. This is how
it is in Xorg and the session now.

Mapping KEY_SUSPEND to hibernate is just insane. Can you please change
the toshiba driver to use KEY_HIBERNATE and KEY_SUSPEND as thinkpad
now does? Thanks.

Richard.
