Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbXEJM4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbXEJM4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbXEJM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:56:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:42570 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758741AbXEJM4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r9iYTJc6nVxhKRqo4ldKdxHmhPAEvOpWgIQ9CNz5JwSglFWdvxWK8rAL1h19u6sfdwc99Ui9UW89z7Fg3NxNvO2Mxiijs+UmJBjVglxLWmOPo1Yf9fcMzOOOxl/vYjjnPxcwdeNxRAhtGnoVY23w9vj4XUDadL1Tdp4olocEAnI=
Message-ID: <d120d5000705100556o7adbeceeoc767484049b9df9e@mail.gmail.com>
Date: Thu, 10 May 2007 08:56:06 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Frederik Deweerdt" <deweerdt@free.fr>
Subject: Re: ixp4xx compile error (was Re: 2.6.21-mm2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it
In-Reply-To: <20070510124526.GD17402@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	 <20070510122129.GC17402@slug> <20070510124526.GD17402@slug>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Frederik Deweerdt <deweerdt@free.fr> wrote:
>
>  static int ixp4xx_spkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
>  {
> -       unsigned int pin = (unsigned int) input_get_drvdata(input_dev);
> +       unsigned int pin = (unsigned int) input_get_drvdata(dev);
>        unsigned int count = 0;
>

Yep, my fault. Please forward this to Linus.

-- 
Dmitry
