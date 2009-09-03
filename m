Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZICGRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZICGRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZICGRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:17:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:24535 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZICGRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:17:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CSe8df6aWJC10rIV7i3rl1xyurmqaelSM/uzUKFKoeqnCl2NkC4WTEm/Jh1x4NggJM
         TLXi0oWufORW0d6i5R9VcIpW5pQxXagkW578NVQF6prJPAyp3TErUHgJNaC4cU9Ne3QH
         roim2ydVC0PRhTKy5UsEaV4JY1oBqAfwNl8zE=
MIME-Version: 1.0
In-Reply-To: <1251942059-21448-6-git-send-email-lrodriguez@atheros.com>
References: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
	 <1251942059-21448-6-git-send-email-lrodriguez@atheros.com>
Date: Thu, 3 Sep 2009 09:17:13 +0300
X-Google-Sender-Auth: 68016e53b6eee301
Message-ID: <84144f020909022317m776bbf86xe523144451f97693@mail.gmail.com>
Subject: Re: [PATCH 5/5] kmemleak: fix sparse warning for static declarations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 4:40 AM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> This fixes these sparse warnings:
>
> mm/kmemleak.c:1179:6: warning: symbol 'start_scan_thread' was not declared. Should it be static?
> mm/kmemleak.c:1194:6: warning: symbol 'stop_scan_thread' was not declared. Should it be static?
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
