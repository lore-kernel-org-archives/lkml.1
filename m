Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYJWLVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYJWLVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYJWLVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:21:13 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:35452 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYJWLVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Gbx+MDf1SnT9i5bbtOdSTmrtm1iayFNgWbSA0iWaWLIRqUxb7Mp9uW0Qy876eNtiYu
         XAXhkMael9hIfh64xEl41BDz5QoJ+0c5zYAga7yKa4IRA81MxJyow0Cik4n/j852itdU
         ksB10GmLH0U9DR8decY8yxzhJLCVY93+9vHW4=
Message-ID: <6ffd69180810230421v1508664bgc6e454cde792154f@mail.gmail.com>
Date: Thu, 23 Oct 2008 04:21:09 -0700
From: "Robert Moss" <robert.von.moss@gmail.com>
To: "Samuel Thibault" <samuel.thibault@ens-lyon.org>,
       "Robert Moss" <robert.von.moss@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Framebuffer issues in 2.6.26 with uvesafb and vesafb. Linux is about choice!
In-Reply-To: <20081023080459.GC5073@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com>
	 <20081023080459.GC5073@const.bordeaux.inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also want to note, that I downloaded 2.6.27.3 and compiled, with
CONFIG_FB_VESA=Y, and still get excactly the same response as from
2.6.26

Thank you for the quick reply, I'm glad to hear that everything is
still supposed to work ^_^.
Ok on both 2.6.24 AND 2.6.26, i get the same thing from vga=ask then scan,
0 F00  80x25
1 F01  80x50
2 F02  80x43
3 F03  80x28
4 F05  80x36
5 F06  80x36
6 F07  80x60

Please select a number

and on 2.6.26 with vga=791 it says

Screen unavailable [or not found, im not sure] 317.  (which i believe
is 0x317 = 791)



On Thu, Oct 23, 2008 at 1:04 AM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
> Robert Moss, le Thu 23 Oct 2008 00:54:56 -0700, a écrit :
>> Anyhow, I noticed that vesafb is no longer a part of the kernel.
>
> That's not true. It works nicely on my laptop (though I don't get
> the native 1280x800 resolution).
>
>> vga=791 still gave a mode not found.
>
> Then that's a bug, which is a completely different thing. Could you
> check that the output of vga=ask and typing scan at the boot prompt is
> the same between 2.6.24 and 2.6.25/26 ?
>
> Samuel, who may want to try 2.6.24 to get his native resolution.
>
