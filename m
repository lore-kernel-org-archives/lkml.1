Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbZDKSIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbZDKSIC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 14:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbZDKSHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 14:07:50 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:63410 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110AbZDKSHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 14:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QQTRtzilg+PJKfPgseDJOcHj1SXATjJpLKNhU1A9IfVw+ZS7Bi6ntAcqCB1JgZ4/+Z
         wLze/UIJZ7BfoA9h7gkh0jTqSdZkO8oY5o5SURqoZgiW4qh0D7jnb93hOf1ZT26A/gTG
         N34+D8O5tFJ72VVrI7/UEPg5oEP2kPhiLRAQU=
MIME-Version: 1.0
In-Reply-To: <49E065CF.6040408@tuffmail.co.uk>
References: <49E065CF.6040408@tuffmail.co.uk>
Date: Sat, 11 Apr 2009 14:07:45 -0400
Message-ID: <66dc75180904111107q645fbb77i3cf927ffab7a7ef0@mail.gmail.com>
Subject: Re: Regression: EEE PC hangs when booting off battery
From: Tzy-Jye Daniel Lin <ephemient@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 5:41 AM, Alan Jenkins
<alan-jenkins@tuffmail.co.uk> wrote:
> Regression #6 on latest git! (last known good is 2.6.29-rc8)
>
> Magic SysRQ keys work though.  Unfortunately, SysRq-W / SysRq-T generate
> too much output, so the useful bits immediately scroll off the top of
> the screen.  I can't press SysRq-P (even if that would help), because
> the SysRQ key on my laptop is accessed using a Fn modifier key, which
> also turns the left hand side of the keyboard into a numeric pad.

I don't own an Eee, but having played with one, the key sequence

    Alt down
    Fn down
    SysRq down, up
    Fn up
    P down, up
    Alt up

should work just fine.  As long as you keep holding Alt, you don't
need to continue holding SysRq after the initial keypress.

> Magic SysRQs on my USB keyboard generate no response.  (Sometimes the
> numlock key seems to work though.  I can't tell on the laptop keyboard
> because the laptop doesn't have a numlock led).

SysRq over USB has never worked.  On PC hardware, Magic SysRq depends
on features of the built-in i8042 controller, which only handles PS/2
input.
