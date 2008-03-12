Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbYCLKkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbYCLKkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYCLKkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:40:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:43116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbYCLKki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kt9ImXRDSkpU3of9obM+YF9J+Poj6FlTPTxICFSwE01Mg+9ApulL6LmA3SBUkoWDAOhOaUwtzFmDlZoOH+BFDxzl+XrBg0FnnwgX/7C+iWfuOAlmUEi33U69X/YP+2teYbDl0BWJN5EorIu+EfZ0zkLpTOqLarFBDA/oUCz+9U4=
Message-ID: <e2e108260803120340u6e42b1d1hd3fc51bb92f21830@mail.gmail.com>
Date: Wed, 12 Mar 2008 11:40:36 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: How to compile kernel so it automatically reboots upon a crash instead of generating stack trace and then hang.
Cc: "Prakhar Krishna" <prakhar2@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0803120602580.18745@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4f2ee0160803112152y21bb99a7t331fc9eff214e756@mail.gmail.com>
	 <Pine.LNX.4.64.0803120602580.18745@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 6:04 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>  On Mar 11 2008 23:52, Prakhar Krishna wrote:
>  >
>  >[I did search the mailing lists archives and the Web but did not find an answer,
>  > apololgies if this is duplicate question]
>  >
>  >i need my linux box to automatically reboot if it ever runs into a
>  >kernel panic/crash etc.
>
>  panic=<timeout> boot parameter, as per
>  Documentation/kernel-parameters.txt.

The best solution in this case is a hardware watchdog. Hardware
watchdogs are present on some server motherboards, most embedded x86
CPU boards and also in PowerPC CPU's. The Linux kernel supports some
hardware watchdogs, see also Device Drivers/Watchdog Timer Support in
the Linux kernel config.

The nmi_watchdog=<timeout> parameter might be interesting too. See
also Documentation/nmi_watchdog.txt.

Bart.
