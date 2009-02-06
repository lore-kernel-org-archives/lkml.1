Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZBFC0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZBFC0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZBFC0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:26:39 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:54535 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZBFC0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:26:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UollXS8sObQ/RNBYMNh38KouOk54FQwY7IzmmTQOFslYStk5c2scELJte6kDzNv+WE
         4A+RjEcrk2Yj12Bv34jtO/sq+T693TDV8G6std3rRM6ix+viowBW7mwN/KGws/IZ3x8z
         uwYCC7xBQryQykbtHSY8YzNCGveuj5fgHgxvY=
MIME-Version: 1.0
In-Reply-To: <20090205141245.2945141e.akpm@linux-foundation.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
	 <1233828453-13311-2-git-send-email-cooloney@kernel.org>
	 <20090205141245.2945141e.akpm@linux-foundation.org>
Date: Fri, 6 Feb 2009 10:26:35 +0800
X-Google-Sender-Auth: 855b3917368a923b
Message-ID: <386072610902051826q23b806b8u6980be0ff83edf53@mail.gmail.com>
Subject: Re: [PATCH 1/5] Blackfin SPI Driver: use bfin_spi_ prefix on all 
	functions
From: Bryan Wu <cooloney@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, vapier.adi@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 6:12 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu,  5 Feb 2009 18:07:29 +0800
> Bryan Wu <cooloney@kernel.org> wrote:
>
>> Do this because when things crash, we get simple names like "setup" and
>> "start_queue" which is pretty difficult to trace back to the real thing:
>> the spi driver
>>
>
> As usual, the driver core guys have gone trompling all over other people's code
> and your patch doesn't apply to linux-next.
>
> 11 out of 61 hunks FAILED -- saving rejects to file drivers/spi/spi_bfin5xx.c.rej
>

That is because our earlier 16 spi patches not merged. As David
request, I will fold those 16 spi patches with these 5 patches and
send them out later.

Thanks a lot
-Bryan
