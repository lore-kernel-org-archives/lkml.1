Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZINRrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZINRrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZINRrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:47:14 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:59054 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZINRrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Km3TOJ2ghNm+3lK/s09Ip8qNEhMSI0NddtWRWbEd5aUgAu9Y9sDPWrD4GgAZZIc/Z9
         jmAXri+i3P3gX4WY1UZxQ+JNzZIZ6RE/8eY49aX5WHXM/JPkmiVcjgoiCB55mz26TcDw
         McIxwJ1RbJrGATtrDDqXG9LRFOK6mcldU2xyI=
From: Corentin Chary <corentincj@iksaif.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 0/3] rfkill_unregister() should always be followed by rfkill_destroy()
Date: Mon, 14 Sep 2009 19:47:22 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-gentoo; KDE/4.3.1; x86_64; ; )
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-acpi@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, Johannes Berg <johannes@sipsolutions.net>
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net> <20090914170717.GA13452@khazad-dum.debian.net> <20090914171056.GB13452@khazad-dum.debian.net>
In-Reply-To: <20090914171056.GB13452@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909141947.22170.corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 September 2009 19:10:56 Henrique de Moraes Holschuh wrote:
> On Mon, 14 Sep 2009, Henrique de Moraes Holschuh wrote:
> > I don't know about the fix for dell-laptop since it is a lot larger.
> 
> But looking at it, it seems to meet the -stable criteria as well.  However,
> it looks like you're fixing two bugs there (set pointers to NULL, call
> _destroy()), so it would be better to have two (smaller) patches, maybe?
> 

The dell-laptop patch is superseded by:
http://patchwork.kernel.org/patch/42705/
http://patchwork.kernel.org/patch/42699/

I didn't check patchwork before working on this patch :/

-- 
Corentin Chary
http://xf.iksaif.net
