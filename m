Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZDDIdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZDDIdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZDDId1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:33:27 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52034 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZDDIdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ArQ02j9Tr3FOmKHAuvczfUgaG/ezT13wclpfO9P9ml8vUZwDGfZmhBmPDEn8ADc6Os
         XZLoz+W/GCAKESgv02/D103N0mNdag0VkumR9yKmTmW0DCOlIng6xvBCAr7xejEMo+5Z
         mAov6a4xC/wwTk8B72gqFsI+pjYHqs6Ev3saI=
MIME-Version: 1.0
In-Reply-To: <20090404041813.GA30746@srcf.ucam.org>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <20090404041813.GA30746@srcf.ucam.org>
Date: Sat, 4 Apr 2009 10:33:20 +0200
Message-ID: <71cd59b00904040133p1f130673r4e93d2c48f8f4616@mail.gmail.com>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via 
	the input layer
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On the other hand, the default behaviour of the acpi video driver is to
> change the brightness itself and then also to send the even to
> userspace, so I guess if it was going to break things it probably would
> have done already...

So, I think this patch is ok.

But there is a thing I don't like is
int brn = -2;
brn = notify_brn();
if (brn != -2)

How can brn be -2 ? And why -2 ?

-- 
Corentin Chary
http://xf.iksaif.net
