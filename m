Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZERVAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZERVAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 17:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZERU7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:59:53 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2020 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbZERU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:59:52 -0400
Subject: Re: [PATCH 0/6] drivers/ide Convert printk(KERN_<foo> to pr_<foo>(
From: Joe Perches <joe@perches.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
In-Reply-To: <1242662198.6347.14.camel@mulgrave.int.hansenpartnership.com>
References: <cover.1242609803.git.joe@perches.com>
	 <200905181612.43632.bzolnier@gmail.com>
	 <1242661288.1572.82.camel@Joe-Laptop.home>
	 <1242662198.6347.14.camel@mulgrave.int.hansenpartnership.com>
Content-Type: text/plain
Date: Mon, 18 May 2009 13:59:49 -0700
Message-Id: <1242680389.1572.127.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 15:56 +0000, James Bottomley wrote:
> What exactly is the point of a mechanical conversion from
> printk(KERN_ ...) to pr_...?
> 
> I can see the value of the pr_ macros from new code in that the
> temptation to put a comma after KERN_.. for some people is irresistible
> so it's an interface that's very easy to misuse, but given that we have
> correct uses, why convert them?

Enables easier conversion to dev_<foo> macros
Allows easier prefixing via pr_fmt
Puts back together unnecessarily chopped up format strings
Standardization is good
Just for the hell of it

cheers, Joe

