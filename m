Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZIJLM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZIJLM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 07:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZIJLM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 07:12:58 -0400
Received: from [89.145.121.108] ([89.145.121.108]:57914 "EHLO faktura.co.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752593AbZIJLM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 07:12:58 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2009 07:12:57 EDT
Subject: Re: disable : Ctrl -C in the Kernel
From: Matt <tank.en.mate@gmail.com>
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
Cc: Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
In-Reply-To: <241b8f7b0909100337sc47f6a6yf1488d1bd7f17a00@mail.gmail.com>
References: <241b8f7b0909100310t267b82cq976929d2f7b7734@mail.gmail.com>
	 <alpine.DEB.2.00.0909101228170.9074@aurora.sdinet.de>
	 <241b8f7b0909100337sc47f6a6yf1488d1bd7f17a00@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 12:03:26 +0100
Message-Id: <1252580606.4133.9996.camel@bryant.faktura.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 16:07 +0530, Prabhu Chawandi wrote:
> Thansk,
> 
> Do u know which is enabling it.
> 
> Coz, after adding the line told by u, I am not able to  disable, means
> somewhere after this place its being enabled.
> 
> 

Firstly, this really isn't a kernel problem; this is the wrong list for
this kind of question.

Secondly, there are typically hundreds of processes started at boot
time, you'll need to check them to find out which is changing the
terminal settings. I would suggest hooking up strace to init somehow and
tracing all the ioctl()s to /dev/tty or /dev/console.

Matt


