Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbYJYUWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbYJYUWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 16:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYJYUWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 16:22:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:40953 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYJYUWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 16:22:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j1OxdgY3VpDDVPCbCGhNh8uduRHYa4eryFNn01UjzTO/CLcsC17lCbVMnSU+0kyIHj
         Bo/5d8LSaXQnBGtcdOTIbvlYYHNiG/qoYslFejTDd1EQnKjBOjYge1asljoUrS7FMyvA
         O+nvqECBcmlgh2K2p/xI7Gbfqns9glcrxpkdA=
Message-ID: <6ffd69180810251322n350b6f6dqf496d7e5972165f5@mail.gmail.com>
Date: Sat, 25 Oct 2008 13:22:33 -0700
From: "Robert Moss" <robert.von.moss@gmail.com>
To: "Samuel Thibault" <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       alistair@devzero.co.uk
Subject: Re: Framebuffer issues in 2.6.26 with uvesafb and vesafb. Linux is about choice!
In-Reply-To: <20081024092418.GA10246@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com>
	 <20081023080459.GC5073@const.bordeaux.inria.fr>
	 <6ffd69180810230421v1508664bgc6e454cde792154f@mail.gmail.com>
	 <20081024092418.GA10246@const.bordeaux.inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, this morning, I turned on my computer, and it gave me the error
message again:

Undefined video mode number: 317

I immediately restarted, and this time appened edd=off to the kernel
line. It started up without incident. But I can't be sure if it was
the appendage that caused it, or if for some reason, it randomly
decided to work, however, because the 2.6.24 kernel never failed me,
and I could never get the other, higher kernels to work (repeatedly) i
believe this may have something to do with it, but of course, i'm not
sure what edd=off does, I would guess enhanced display detection, but
thats just a guess,


On Fri, Oct 24, 2008 at 2:24 AM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
> Robert Moss, le Thu 23 Oct 2008 04:21:09 -0700, a écrit :
>> Ok on both 2.6.24 AND 2.6.26, i get the same thing from vga=ask then scan,
>> 0 F00  80x25
>> 1 F01  80x50
>> 2 F02  80x43
>> 3 F03  80x28
>> 4 F05  80x36
>> 5 F06  80x36
>> 6 F07  80x60
>
> Could you try edd=off?
>
> Samuel
>
