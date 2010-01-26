Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667Ab0AZQTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0AZQTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638Ab0AZQTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:19:20 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62712 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab0AZQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:19:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XmwVoluCfV35MGDv1xXlWrzTx88gAT/MIxIfyNDBRH8AZuDnusLqdfe1XVemM0kqhx
         KkjN8zTF8x8/pLHSO+eap1P5t+vBJmJkCq2isVu2H3potv2xw3+pfa65m0FBF86Xu6PP
         goHxNvN26map4Be0LyY7C0WdQkTHv1SkoWG+Y=
MIME-Version: 1.0
In-Reply-To: <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
Date: Tue, 26 Jan 2010 21:49:18 +0530
Message-ID: <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Vishal Rao <vishalrao@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/26 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> Should work with 64, 128 (tested) and 256 GB capacities with any
>> firmware versions in
>> drivers/ata/libata-core.c because of ATA errors in dmesg, hangs and
>> filesystem corruption.
>
> If you've only tested one type why list all three ? Also you've not
> listed a firmware version so do you know which are affected ?
>
> What controllers did you test with ?
>
> Alan
>

The 3 IDs should match I believe and the firmware parameter is NULL.
Affected firmware versions include at least the latest 1916 and the
previous 1819, likely older ones as well.

Tested with my own Crucial CT128M225 model which has the IndiLinx
Barefoot controller.

The libata-core.c file has an existing line for "OCZ_CORESSD" for a
particular firmware version
but I suspect many, if not all of those controllers may have this issue?
At least one user of Intel SSDs reports no issues with existing
kernels and I've read that
they do NCQ right.
