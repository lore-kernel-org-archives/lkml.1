Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbZFAPKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbZFAPKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZFAPKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:10:13 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:56015 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZFAPKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kicGEpHrrHEi4//MvjDSp4VA2Dk/U+58a0jscNbqvgngEnr+O4WMTvxJtSn54isR3X
         IjMHX+yDnOE9EctsexNoUhfP7VnW7XaS6xy67EdNUI/3nVE3OtWGzUfkwRVFr61RIrPx
         LaQFOdbwgMCKZkD+3ZK0eFKSBbOOhBeK5NJmo=
MIME-Version: 1.0
In-Reply-To: <20090601160721.7b262469@lxorguk.ukuu.org.uk>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-2-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-5-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-6-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-7-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-8-git-send-email-dbaryshkov@gmail.com>
	 <1243868091-5315-9-git-send-email-dbaryshkov@gmail.com>
	 <20090601160721.7b262469@lxorguk.ukuu.org.uk>
Date: Mon, 1 Jun 2009 19:10:11 +0400
Message-ID: <bc64b4640906010810l8ace77byfbd650b549f9b5c3@mail.gmail.com>
Subject: Re: [PATCH 08/10] tty_io: export tty_class
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/1 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Mon,  1 Jun 2009 18:54:49 +0400
> Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:
>
>> Currently tty_class in a public variable in the tty_io.c
>> Export it to the modules to allow some usefull tricks.
>
> Thats exactly why it isn't exported. We don't want "tricks".

I'd like to find a struct device corresponding to the struct tty_struct
from the ldisc .open call. What would be the best way for me to do this?
I used class_find_device finding the device with matching minor. Will it be
acceptable, if I just move this code into tty_* file and export it as
to modules?


-- 
With best wishes
Dmitry
