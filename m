Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbXJUR5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbXJUR5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 13:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXJUR5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 13:57:22 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:36601 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbXJUR5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 13:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qj+6Y5JGOo+6Trfd6ey7j3VxHyfIg7ihPEGn0M5EG+LEMxO+jgGn6U32m+xg0qay24GSsdE0L3Y1V9bgMrcxPqKu+tpc8k2tBaeErfW5FWF5XAdBvhtpmAh58FMzKVuepvfBZs5HDMwQ3eJr+wDm1PPLAC+dt8yjUGxj+mIBqzY=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 10/17] drivers/input/serio/i8042.c: irq handler clean
Date: Sun, 21 Oct 2007 13:57:16 -0400
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org> <20071021075237.EC51B19041D@havoc.gtf.org>
In-Reply-To: <20071021075237.EC51B19041D@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710211357.16794.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Sunday 21 October 2007, Jeff Garzik wrote:
> commit bdf311215ef8dbae0254c092deaed1d5928b013e
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Oct 19 19:28:54 2007 -0400
> 
>     drivers/input/serio/i8042.c: irq handler clean
>     
>     * remove unnecessary prototype
>     
>     * distinguish between polled and irq-driven event handling
>     
>     * don't bother worrying about 'irq' function arg

I don't like these 2 changes. When I ask for debug data I really
want to know what interrupt (1 or 12) was raised in response to
a command. Your changes remove this visibility.

>     
>     * dev_id passed to irq handlers is unused, to change the request_irq()
>       argument to NULL
>     

Does this really matter?

Thanks.

-- 
Dmitry
