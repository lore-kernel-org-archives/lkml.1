Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbYF3T6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbYF3T6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761083AbYF3T5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:57:52 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:14720 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbYF3T5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QtX/PehT5qmjqwUMgMgq1mPrFSmbv5fC818QOb3PyPUN3NJ46v/rShKlK7DIC4lBJR
         LCC1+b9FgNz2ZIX/N/kJMxPHawYqpHduCbTjTr1W5NAiVG+wzOVYukI/CJfeIcU1yTOe
         PBIGAqzr6qWFhhE4bqAxc+OzdUZ4sZtVgBV+w=
Message-ID: <48693A5B.9040901@gmail.com>
Date: Mon, 30 Jun 2008 21:56:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: JosephChan@via.com.tw
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, geert@linux-m68k.org
Subject: Re: [PATCH 11/13] viafb: viafbdev.c, viafbdev.h
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7895@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7895@exchtp03.taipei.via.com.tw>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2008 09:46 AM, JosephChan@via.com.tw wrote:
> Initialization, remove and some other important functions of viafb.
> 
> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 
> diff -Nur a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> --- a/drivers/video/via/viafbdev.c	1970-01-01 08:00:00.000000000 +0800
> +++ b/drivers/video/via/viafbdev.c	2008-06-30 08:53:33.000000000 +0800
> @@ -0,0 +1,2659 @@
[...]
> +static int timer_on;
> +struct timer_list timer_for3D;

Well the timer is neither inited nor used... ?
