Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZK2Vv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZK2Vv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZK2Vv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:51:27 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:36670 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZK2Vv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=k8Fz6ZHLp5ngBkhPkCF30hmhJ0CXooF//W/S2OtgLUsPWWv/03QOypntjtlvEz8qxY
         0Arkg//jLXAL+feq/XGj+spuphkgQgc25zaWl39yQoEaTs04kIkqZy+ZRE6rZn/b34Tc
         BnSODvGW68PmmSU4J/dmlpBzyLt+h7CHCc9B0=
MIME-Version: 1.0
In-Reply-To: <b170af450911291209o33ebfc36n850826e54096f3b4@mail.gmail.com>
References: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com>
	 <b170af450911291209o33ebfc36n850826e54096f3b4@mail.gmail.com>
Date: Sun, 29 Nov 2009 22:51:31 +0100
Message-ID: <b170af450911291351r443e355fraf1828dc1163e9e3@mail.gmail.com>
Subject: Re: Backlight device class redesign
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 29 listopada 2009 21:09 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> So I think we have to register every device and just keep symlink
> /sys/class/backlight/display_name pointing best device. We could
> register devices in
> 1) /sys/class/backlight/.devicename (hidden)
> 2) some /sys/class/internal-usage/devicename
>
> Do you agree on this?

Please, see attached patch. TODO:
1) Add METHOD (enum { ACPI, GPU, PLATFORM} ) as
backlight_device_register parameter
2) Add display name as backlight_device_register parameter
3) Use given METHODs in backlight_best_device
4) Fix symlinks to be created in /sys/class/backlight/ instead of
/sys/dev/char/ (how?!)

What about proposed solution?

-- 
Rafał
