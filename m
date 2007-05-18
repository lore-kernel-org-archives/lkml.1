Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbXEROUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbXEROUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbXEROUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:20:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:46235 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbXEROUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bZB0qHyH8cpEwcIff8b6y5bSROZhzQQgmou9Q7ellwoN7OV4e4IFrW5xMCuq74opV2rZeCVIrnGzdf3Gus1oxXrsZj42ZV5e8PBIIdmOUVprj4m/vOK6qtZJAeXpAs5Y5OEgmVo9LEpGLgmGxPBfqrArbHBhjV3qjlPxKhU1SfQ=
Message-ID: <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com>
Date: Fri, 18 May 2007 16:20:39 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Martin Mokrejs" <mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted
Cc: linux-kernel@vger.kernel.org, ext3-users@redhat.com
In-Reply-To: <20070518090604.GA10841@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070518090604.GA10841@ribosome.natur.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/07, Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz> wrote:
> Hi,
>   I just tried the 2.6.22-r1 candidate to test whether some bug I have
> hit in the past still exists. I did use 2.6.20.6 so far. So, I have
> cleanly rebooted to use the new kernel, after the machine came up I
> tried to mess with the bug, and had to reboot again to play with kernel
> commandline parameters. Unfortunately, on the next reboot fsck was
> schedules on my filesystem after 38 clean mounts. :( And the problem
> started. The fsck found some unused inodes, but probably did not know
> where do they belong to, but it deleted them automagically. Finally, the
> fsck died because it cannot fine some '..' entry.
>

How do you know that the corruption was caused by 2.6.21-rc1 ?
Isn't it possible that the corruption was created by an earlier
kernel, but only detected when a forced fsck was run - which just
happened to be while you were running 2.6.21-rc1 ...

My point is that, as far as I can see, there's nothing tying
2.6.21-rc1 specifically to this corruption... or?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
