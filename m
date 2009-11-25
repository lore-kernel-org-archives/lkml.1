Return-Path: <linux-kernel-owner+w=401wt.eu-S934777AbZKYNjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934777AbZKYNjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934744AbZKYNjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:39:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34416 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934698AbZKYNjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=svgIl8vlK5FzfbSzCzwPTJZqKin5dJybzX7mKcr0vdklp2wM/wJYnAm6klkj1rmmfg
         EU+hqFlaIlnyvbNc97QozpzBgTEnTa9Mcc1AoBjgKJoqO2aq/xj2JDBqUDspv1ZhF/lq
         P4f8+QClTNYJ9RkALIKRvtjMUjMbaI2StKY+g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 02/38] move atp870u_remove to .devexit.text
Date: Wed, 25 Nov 2009 14:38:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@linux.intel.com>,
       linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de> <1259098696.4549.643.camel@mulgrave.site>
In-Reply-To: <1259098696.4549.643.camel@mulgrave.site>
MIME-Version: 1.0
Message-Id: <200911251438.24846.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 November 2009 10:38:16 pm James Bottomley wrote:
> On Tue, 2009-11-24 at 22:06 +0100, Uwe Kleine-König wrote:
> > The function atp870u_remove is used only wrapped by __devexit_p so define
> > it using __devexit.
> 
> But there's really no point to this.  HOTPLUG is always defined on SCSI
> systems that have these drivers, which means that _devinit/exit are
> nops.  That makes the change purely cosmetic and not worth churning two
> dozen drivers for.

Looking at things from a bit different angle:

These tags still have some value as a documentation and help
in maintaining some level of the coherency between different
parts of a kernel (which is a Good Thing).

--
Bartlomiej Zolnierkiewicz
