Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZBUIWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZBUIWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 03:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZBUIVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 03:21:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:52406 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZBUIVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 03:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V5eIQIqh0dpYihh4cbpwseuo17ZijQmOdHUnX8AvwO8w8+tp1iUZOpmsns9qD5+1jj
         DjFPLF9/0IKX1hFqMBhCN79ESNO1+AgRx2BCutjsphTwauyFkt+r64giTjSnqKvFSWGS
         QBkFSYLZe09GwC00CYL70FaPYxSu/Zb8qcSIk=
MIME-Version: 1.0
In-Reply-To: <20090220202941.6c33b627@infradead.org>
References: <1235139447-5829-1-git-send-email-tom.leiming@gmail.com>
	 <20090220073345.501247f7@infradead.org>
	 <d82e647a0902201728s5e57f02cs8f8c20567f914717@mail.gmail.com>
	 <20090220202941.6c33b627@infradead.org>
Date: Sat, 21 Feb 2009 16:21:51 +0800
Message-ID: <d82e647a0902210021m27cb1c18s9bf7edb7ffe08d68@mail.gmail.com>
Subject: Re: [PATCH] [PATCH/RESEND] driver core: remove polling for 
	driver_probe_done(v4)
From: Ming Lei <tom.leiming@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: kay.sievers@vrfy.org, greg@kroah.com, cornelia.huck@de.ibm.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> that is not the right solution. The patch that introduced
> wait_for_device_probe() was there to make sure it all happens in one
> central location. To then decentralize this 2nd function call to all
> locations that call the function does not make sense to me.....

OK, I'll resend a patch, which add async_synchronize_full() in
wait_for_device_probe().

Thanks!

>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>



-- 
Lei Ming
