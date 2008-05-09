Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbYEILYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbYEILYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYEILYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:24:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:39027 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYEILYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=b20PN/5nVx5nR6nZBeMID4mY+cexNM+rvLUmXdq47jfH8wfPWqtqA9Dc31odoZhlyyZMyv9Bw9BJ95NTKqxKa8Kd+ZuatMJbnE/Iwj5hbFQLk6BUlmesEMxTQyTZy/iYLBsPvOyxVEobWPzxCeE9zmitF60UlHAm613XCHPs1w0=
Date: Fri, 9 May 2008 19:22:51 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: toralf.foerster@gmx.de
Cc: Ingo Molnar <mingo@elte.hu>, WANG Cong <xiyou.wangcong@gmail.com>,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Travis <travis@sgi.com>
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
Message-ID: <20080509112251.GM2543@hacking>
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509095244.GJ2543@hacking> <20080509095837.GB19617@elte.hu> <200805091259.20126.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805091259.20126.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 12:59:17PM +0200, =?ISO-8859-1?Q?Toralf_F=F6rster_ wrote:

>ERROR: "i2c_master_send" [drivers/media/video/tuner.ko] undefined!
>ERROR: "i2c_detach_client" [drivers/media/video/tuner.ko] undefined!
>ERROR: "i2c_del_driver" [drivers/media/video/tuner.ko] undefined!
>ERROR: "v4l2_i2c_attach" [drivers/media/video/tuner.ko] undefined!
>ERROR: "i2c_register_driver" [drivers/media/video/tuner.ko] undefined!
>ERROR: "i2c_master_recv" [drivers/media/video/tuner.ko] undefined!
>ERROR: "i2c_probe" [drivers/media/video/tuner.ko] undefined!
>ERROR: "i2c_transfer" [drivers/media/common/tuners/xc5000.ko] undefined!
>ERROR: "i2c_transfer" [drivers/media/common/tuners/tuner-xc2028.ko] undefined!
>ERROR: "i2c_transfer" [drivers/media/common/tuners/tuner-simple.ko] undefined!
>ERROR: "i2c_clients_command" [drivers/media/common/tuners/tuner-simple.ko] undefined!
>ERROR: "i2c_transfer" [drivers/media/common/tuners/tea5767.ko] undefined!
>ERROR: "i2c_transfer" [drivers/media/common/tuners/tea5761.ko] undefined!
>ERROR: "i2c_transfer" [drivers/media/common/tuners/tda9887.ko] undefined!
>ERROR: "i2c_transfer" [drivers/media/common/tuners/tda8290.ko] undefined!
>ERROR: "i2c_transfer" [drivers/media/common/tuners/mt20xx.ko] undefined!
>make[1]: *** [__modpost] Error 1
>make: *** [modules] Error 2

Hmmm, it seems a similar issue has already solved in this thread[1].
Maybe you should try Andrew's patch[2].

Thanks!

1. http://lkml.org/lkml/2008/4/30/77
2. http://lkml.org/lkml/2008/4/30/144
