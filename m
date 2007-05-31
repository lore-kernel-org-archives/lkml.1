Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbXEaJS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbXEaJS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbXEaJSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:18:52 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:34325 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbXEaJSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qZ7cLfbokf53zanOyrDQMy3HsiDnpUf8LHmdEaRJlWZq/FGLf7tDK0eskhNBFkoO1lyMDbgUQJqPLRgiG9DY7bFmXBtI3NBpAaN4DHlG+1hTpGyaACrjtqBwseLnZSFjQI1puZe3vEmjAAm2gITwnIAHX3rjMP7x49LS49Bw4As=
Message-ID: <6278d2220705310218x2736f652wb8d17095a9a82e6f@mail.gmail.com>
Date: Thu, 31 May 2007 10:18:48 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: Compact Flash performance...
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <75b66ecd0705301531q1ba78d39od07d2611573c9150@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
	 <75b66ecd0705301531q1ba78d39od07d2611573c9150@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/07, Lee Revell <rlrevell@joe-job.com> wrote:
> On 5/30/07, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> > I have a SanDisk Extreme IV 4GB CF card, capable of 40MB/s read, but
> > am seeing 30MB/s read [1], connected directly to the IDE bus on my
> > ICH8 controller.
>
> How do you know it's capable of 40MB/s read?

Hi Lee,

There are various reports of users getting 40MB/s == 38.1MiB/s with
UDMA mode 6 media readers (which are few and far between):

http://www.robgalbraith.com/bins/content_page.asp?cid=7-7896-8475
http://www.it-enquirer.com/media/screenshots/sandisk-extreme-bench.png

If a particular reader is able to get 40MB/s through the CF interface,
then this most likely will be achievable with ICH8+Linux also, but
perhaps parameters need to be tuned or the right IDE configuration
needs to be reached etc.

> Lee
-- 
Daniel J Blueman
