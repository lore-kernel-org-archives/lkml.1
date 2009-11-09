Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZKIUH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZKIUH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZKIUH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:07:26 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36829 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbZKIUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=ocKlkbeeC+J2Cu6dUrfNM10dIfiEYDKSAl43plJIzMD6biWgfQkHzjTXgp+1IU4WxF
         ZbFPeM1cdGK+wrnkOcJGz/75A4ZNwqJ543p9uSad/7GF+JJWA6OOXc0orSPPj5D7pijr
         b5W4dOXcqLs0TWkbYP4aP8lHtYPp9VLa0hC0M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH] Staging: rt28x0: remove no longer needed common/cmm_data_2860.c
Date: Mon, 9 Nov 2009 21:06:32 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <200911091720.39821.bzolnier@gmail.com> <50BD09C528%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <50BD09C528%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Message-Id: <200911092106.32462.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009 18:54:38 Darren Salt wrote:
> Your removal of cmm_data_2860.c also removes a bug fix (commit
> 0af49167b1e5ba154e90d2c454bf4624ee47df80; for background, see
> http://bugzilla.kernel.org/show_bug.cgi?id=13390).

commit 0af49167b1e5ba154e90d2c454bf4624ee47df80
Author: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date:   Wed Oct 14 02:19:22 2009 +0100

    Staging: rt2860sta: prevent a panic when disabling when associated

while:

ommit 5d315c4baa7be30e0fb8c924a64406492b2263b8
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Tue Sep 22 20:44:07 2009 +0200

    Staging: rt28x0: updates from vendor's V2.1.0.0 drivers

dropped cmm_data_2860.o from the build..

This must be one "lucky" bug looking at how things went subtly wrong
few times..  Pretty amazing..

> Is this fix present (or, better, not needed) in the code which obsoletes this
> file? (I can test if needed; just point me in the right direction wrt patches
> or repositories.)

It seems it is still needed so could you port it over to cmm_data_pci.c
(just use staging or linux-next as a base)?

Thanks.
-- 
Bartlomiej Zolnierkiewicz
