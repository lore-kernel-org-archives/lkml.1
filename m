Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYCXOlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYCXOlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 10:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758766AbYCXOl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 10:41:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:3603 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392AbYCXOl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 10:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bIHAwA6n4S3X4FNwDjg4Wjkdu6mC7nh3tKqFkm87ujoTCu4iONMN/u0kOfNbQiX0f9+XTEVe8EbPIS4pqGUnhFTxk4YeQa+YpC9HISNeQJTJjEf0ywKqHb5M5GL/eY4r4EsKwqnIscWSQoFfGBcWQaouqPp29nECkcRAprpkTTY=
Message-ID: <1ba2fa240803240741n5bf042c2j4aaa4d2f70cf8ef@mail.gmail.com>
Date: Mon, 24 Mar 2008 16:41:25 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: SDIO: IO-Ready Bit
Cc: linux-kernel@vger.kernel.org, benzizbit@gmail.com
In-Reply-To: <20080324145352.6262788b@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1ba2fa240803180400y1d7a2740t2c21b8b73a755016@mail.gmail.com>
	 <20080318123325.0843b854@mjolnir.drzeus.cx>
	 <1ba2fa240803181043v511df0b6tbe43174feb2f7537@mail.gmail.com>
	 <20080318192018.1815fd57@mjolnir.drzeus.cx>
	 <1ba2fa240803221510n8d5800ft32e0ffa179542aba@mail.gmail.com>
	 <20080324145352.6262788b@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 3:53 PM, Pierre Ossman <drzeus@drzeus.cx> wrote:
> On Sun, 23 Mar 2008 00:10:19 +0200
>
> "Tomas Winkler" <tomasw@gmail.com> wrote:
>
>  >
>
> > I couldn't find anything that can prevent the probe function to be
>  > called in case the module is already loaded. I've looked at udev and
>  > HAL and no much I found.
>  > I will dig into kernel sources, maybe finding out how can be bus
>  > enumeration triggered again or something like this.
>  > Any pointers will be appreciated.
>  >
>
>  Here's the patch that added the functionality:
>
>  http://lkml.org/lkml/2007/4/27/466


Thanks a lot. I will look at this and how it can be used.

Anyhow I've seen that concept of parallel probe is not so new. It was
in 2.6.18 and removed in 2.619.
Probably different approach, maybe more would be adding a parallel
initial function.
Probe will just register to the bus and relevant subsystem, it will be fast.
Optional Initialization function will run after probe in different
thread, this would be the place for running FW download.
Device won't be considered initialized till this function haven't
completed or is not implemented.


Any comments are welcome.

Thanks
Tomas



>  Rgds
>  Pierre
>
