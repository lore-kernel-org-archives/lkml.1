Return-Path: <linux-kernel-owner+w=401wt.eu-S933978AbZKXVWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978AbZKXVWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933394AbZKXVWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:22:48 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:42766 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179AbZKXVWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:22:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Jn7LDFeKUwrN1uY/J+QTC7UT7OjKc2yBGEbsMmYG/02BzaxzSDKMThmVOZGxNzw+j2
         lviiXke83twG/KROhJUDBRoHHixnkDZeIORd22WaRf9WnzAdgQt952uXSV4Eeo/fuDas
         ngcW6YaxRAHiJAM4KBA6fLUh7CXlIy+ZwJYYw=
MIME-Version: 1.0
In-Reply-To: <1259096853-18909-20-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-13-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-14-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-16-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-17-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-18-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-19-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-20-git-send-email-u.kleine-koenig@pengutronix.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 24 Nov 2009 16:22:33 -0500
Message-ID: <8bd0f97a0911241322g7816359u177aa35a36c24356@mail.gmail.com>
Subject: Re: [PATCH 20/38] move spidev_remove to .devexit.text
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Wolfgang Ocker <weo@reccoware.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net,
       Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/24 Uwe Kleine-König
> The function spidev_remove is used only wrapped by __devexit_p so define
> it using __devexit.

this doesnt go far enough to address actual section mismatch issues in
the driver.  i posted a more complete one here:
http://lkml.org/lkml/2009/10/13/76

and akpm has picked that up
-mike
