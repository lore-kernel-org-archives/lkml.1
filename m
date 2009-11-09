Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZKIQtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZKIQtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZKIQtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:49:47 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:51862 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbZKIQtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:49:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nqhXJEEvLpQHT+r7PR1lkE6PnzxNMONfeGr5qfXVC03LXNF7vzKCQOAGEcD/wyBGtS
         MZBZnGKvhr5sXFWFGT2DoDT/QqkYPH5HZmJY5/tLdx6baaa6w24gVHVik+DlFrq489s8
         Ib0sRSl3FCtx0KkDwO6+wjfb26HWIi2bm3cR4=
Message-ID: <4AF84828.7070807@lwfinger.net>
Date: Mon, 09 Nov 2009 10:49:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: Re: [PATCH] Staging: remove rtl8187se driver because of lack of development
 activities
References: <200911091731.36861.bzolnier@gmail.com>
In-Reply-To: <200911091731.36861.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 10:31 AM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] Staging: remove rtl8187se driver because of lack of development activities
> 
> This driver hasn't seen any real development activities since early July:
> 
>    257bc86   Staging: rtl8187se: remove unused #include <linu
>    2035beb   param:remove-useless-writable-charp
>    305409a   tree-wide: fix some typos and punctuation in com
>    b881c6c   Staging: fix wireless drivers depends
>    a010a33   Staging: rtl8187se/rtl8192e/rtl8192su: allow mod
>    125b181   staging: Add proper selection of WIRELESS_EXT an
>    b3184e1   Staging: rtl8187se: Fix comment-out-typo
>    b6ac161   Staging: ARRAY_SIZE changes
> 
> so remove it for now.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

NACK. I am currently using this driver as a template for the development of a
mainline rtl8187se driver. Removing the staging version would not matter to me,
but it would complicate matters for my tester (Bernhard Schiffner
<bernhard@schiffner-limbach.de>). I do not have the hardware, thus I rely on his
help.

Larry

