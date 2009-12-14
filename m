Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbZLNWuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbZLNWuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758488AbZLNWt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:49:58 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:64704 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656AbZLNWty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:49:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=jZY7SDhtLcLN/k7rLWE5GnPN/v82pRwgW7OiEv+NJIZZ1h6HBroBOYd0WXoQXnsqCD
         18MJDGlf6+Rs69ZD820laW8fS/fXbvXZjTPs5XRWVw9BwIikdY0o4lwkV0YI7euC3hfy
         5WigNhBkinasHIRFImlQKrD1k8cZ1Ch5dWXz4=
Date: Tue, 15 Dec 2009 07:44:23 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 2/8] Mark sleep_on as deprecated
Message-Id: <20091215074423.0dd2911c.minchan.kim@barrios-desktop>
In-Reply-To: <20091214212351.BBB4.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
	<20091214210823.BBAE.A69D9226@jp.fujitsu.com>
	<20091214212351.BBB4.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 21:24:40 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> 
> sleep_on() function is SMP and/or kernel preemption unsafe. we shouldn't
> use it on new code.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

We would be better to remove this function.
But it's enough to that in this patch series.  
We have to remove sleep_on with another patch series. 

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
