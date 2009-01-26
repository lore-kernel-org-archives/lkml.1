Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbZAZVGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbZAZVGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZAZVGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:06:24 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:41278 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752248AbZAZVGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:06:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CcS7jAlAP0batZJibVIQGWwAPPsRM3+cq82SK0y03sCfSIJGaIQ2cpaVND/RXiE6NXv/Sb8EgInLxcfMvvl4Qe5/KAZx6sOq3ibFpYZLYuHbTTX57SLoQWcLY5JBp7Ae0j0+Tr6tSahT1O+EFmnKh34+93Q+fRFJW6JgJhRCqAQ=  ;
X-YMail-OSG: lu2d_KYVM1njaBKyWYIJwe.WhzQVFdsnJiZ.grWy0eqHu6fNiABm1B3Wf1FV4A3hRVjoOY.fPqw64cr6rLYx_QaenniDgvx5Dni.92UDv.g1FR2uRin3Svla7f7fzW7N9VxcPmrvw8Ki8FPq9bk1fowdG6mc5.aK56LudOHCtSGFNzqryW3pRjF2nu5L4Cz5izNQ6jWcP8MrDgpUXhzVnG_MdVDz4Az4y2G98jmTyQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ed Swierk <eswierk@aristanetworks.com>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Date: Mon, 26 Jan 2009 13:06:20 -0800
User-Agent: KMail/1.9.10
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       BARRE Sebastien <sbarre@sdelcc.com>
References: <1231177261.13443.20.camel@localhost.localdomain> <20090120114304.3b956189@hyperion.delvare> <1232951630.1329.4.camel@localhost.localdomain>
In-Reply-To: <1232951630.1329.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901261306.21059.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 January 2009, Ed Swierk wrote:
> Here's another attempt at a patch for rtc-ds1307 that allows the driver
> to work with SMBus controllers like nforce2 that do not support i2c
> block transfers.  The byte-oriented compatibility routines now give up
> after 10 unsuccessful attempts to read or write a block of registers
> without conflict.
> 
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

Well, other than the *conceptual* ugliness of this (which
we seem to be stuck with, courtesy the board designer) ...
I have two patch format issues:

 - Always put a line of whitespace after variable
   declarations.

 - Include text like the above as part of the patch,
   even if you're stuck with a mailer that mangles
   non-attached text.

You're using Evolution, which is mentioned in the
Documentation/email-clients.txt file as having a
way (albeit awkward) to send normal patch email.

Given those changes:

  Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Thanks.

- Dave
