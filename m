Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbXFXUAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbXFXUAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXFXT7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:59:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:43733 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbXFXT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V2pRgoCijBkrhntRrjvYuhwOfTslwH3wQB59b0yUYO7zIfj2zBcy7O5K216RQniu1d7s/UvNDrS1dy6PNQSQUgBMDW+nDSIfGvyGxRq4fC/zTPfI19jNqLzu2t5CsgXW64o8b8BYKpxeLYMBpLArxW9eaJJW+gEQ7Be0alF8/Co=
Message-ID: <7e63f56c0706241259u6e123ed6yc02b76f0260adaa5@mail.gmail.com>
Date: Sun, 24 Jun 2007 21:59:39 +0200
From: "Robert Iakobashvili" <coroberti@gmail.com>
To: djones@rossove.com
Subject: Re: Scaling Max IP address limitation
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070624110236.fa36b2f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467EA7C1.4080006@rossove.com>
	 <20070624110236.fa36b2f9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Sun, 24 Jun 2007 12:20:01 -0500 David Jones <djones@rossove.com> wrote:

> > I am trying to add multiple IP addresses ( v6 ) to my FC7 box on eth0.
> > But I am hitting a max limit of 4000 IP address . Seems like there is a
> > limiting variable in linux kernel (which one? ) that prevents from
> > adding more IP addresses than 4096. What do I need to change in Linux
> > kernel  ( and then recompile ) to be able to add more IP addresses than
> > 4K addresses per system? ..


We are adding tens of thousand IPv4 addresses using netlink interface
without any problems. The maximum we added was 60K of secondary
IPv4 addresses. It consumes some memory, however.

We have also added thousands of IPv6. I will try to test, if there is any
limit for doing it.

-- 
Sincerely,
Robert Iakobashvili,
coroberti %x40 gmail %x2e com
...........................................................
http://curl-loader.sourceforge.net
A web testing and traffic generation tool.
