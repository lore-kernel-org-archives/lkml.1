Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXDIUFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXDIUFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965393AbXDIUFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:05:22 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352AbXDIUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:05:21 -0400
Date: Mon, 9 Apr 2007 13:04:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: Dmitry Torokhov <dtor@insightbb.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, rlove@rlove.org, linux-kernel@hansmi.ch,
       Jean Delvare <khali@linux-fr.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Apple SMC driver - fix input device
Message-Id: <20070409130432.f4902155.akpm@linux-foundation.org>
In-Reply-To: <461A455C.9040508@boichat.ch>
References: <45F7C083.7090504@boichat.ch>
	<45FE1D44.8000805@boichat.ch>
	<200703221137.35906.dtor@insightbb.com>
	<461A455C.9040508@boichat.ch>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2007 21:53:32 +0800
Nicolas Boichat <nicolas@boichat.ch> wrote:

> Fixed all these. Thanks.
> 
> Andrew, could you please push this patch in mm too?
> 
> Best regards,
> 
> Nicolas
> 
> - Invert y axis on input device.
> - Only activate the input device polling timer when the device is open.
> - Others minor fixes asked by Dmitry Torokhov.
> 
> Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>

Thanks.

I've been assuming that this patch will go via Jean, since it is in
drivers/hwmon/applesmc.c.  But perhaps that is inappropriate, and it is
more a Paul or Dmitry thing.  Or a me thing.

Who wants to take it??
