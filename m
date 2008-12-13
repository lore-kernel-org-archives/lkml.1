Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbYLMQnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbYLMQnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYLMQno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:43:44 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:42192 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYLMQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:43:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NLO1cAGWJa4ydqbn/YG695NfX7ii18D6py4KZ5/MHZSvGtmJC/4wvW67P0trp0T7ki
         nXYOedegoAR1sCr35oGZGkPRLlbSR8tpVcBF9pC7bRQ178i3UQVqVRyEvyUSdkKlZKWM
         TsDhBdbyoPqbdQe9qnW9duW06OCMpSWaukYgQ=
Message-ID: <c62985530812130843q21142a2uf8e24482da90a8ae@mail.gmail.com>
Date: Sat, 13 Dec 2008 17:43:40 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Giangiacomo Mariotti" <giangiacomo.mariotti@gmail.com>
Subject: Re: [PATCH] Misuse of sizeof
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/13 Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>:
> IMO there's a bug in the use of sizeof in /arch/x86/boot/main.c, it's
> also a strange style.
>

Hi,

No this is not a bug, sizeof is a unary operator which can be used
with or without parenthesis :-)

Note: don't forget to put your Signed-off-by and some explanations
along your patches.
Also, not all maintainers accept patches as attachment.
