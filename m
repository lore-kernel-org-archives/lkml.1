Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXDJLZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXDJLZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXDJLZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:25:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:20897 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXDJLZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I/D6x0HZdeukextDhBGoUomhxgwvirBZvJ6FDcEeKfh9c73jCQMy09tJH5nWmovJgHrgEBUX3QHWQtky9SD/i497s88sdacNWwRavatisB+on28VPPHFPTEgqlSbZX/sG2D4XEsoFH+exYwGZHFn3+6p7dyq2FyY5Hm2ecv7Ktc=
Message-ID: <9a8748490704100425t34ebafcdq866a923df80b9aca@mail.gmail.com>
Date: Tue, 10 Apr 2007 13:25:56 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: Bartek <poemann@gmail.com>
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <19061b0b0704100219w4749e5fby9b400edca9bf334d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19061b0b0704071111m65c70d1ei736de86ad2f09a82@mail.gmail.com>
	 <20070407.234708.93384523.davem@davemloft.net>
	 <19061b0b0704081315g3593d652s70e9b5b0dcfcf966@mail.gmail.com>
	 <19061b0b0704100219w4749e5fby9b400edca9bf334d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/07, Bartek <poemann@gmail.com> wrote:
> > Apr  8 21:47:22 localhost kernel: EIP:    0060:[<c021b4d7>]
> > Tainted: P       VLI
>
> Someone  in private took me a noticed of a still tainted kernel. I
> didn't noticed that, I am sorry for that. I was sure that unloaded
> proprietary modules should resolve the problem. My fault. I will try
> to reproduce the crash  again.
>

It is not enough to unload proprietary modules. As long as they have
ever been loaded at all the kernel is tainted.
You need to ensure that the proprietary modules never get loaded at
all. I guess you probably already worked that out, just wanted to
point it out just in case :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
