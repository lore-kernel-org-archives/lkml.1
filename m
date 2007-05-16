Return-Path: <linux-kernel-owner+w=401wt.eu-S1031148AbXEPVNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031148AbXEPVNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762608AbXEPVN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:13:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:55534 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbXEPVN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sLQVoIiGh19WyNwp5nh9b3R1ZpwJzj0o6BRSh/5PPlAofV3oAsYC4JfyumTRjZ8c/46+x4ghWASqYauKTg6tuOMPzZbfnCh2S2gEIr10uXyYGlrmtBaByn3Ae94k2qJt/4ak3WpsZdFcA4CJgJbJuOy4WzxmoH0ejGRlTwne9rc=
Message-ID: <6bffcb0e0705161413s5008e3b9o90a6e769121184e4@mail.gmail.com>
Date: Wed, 16 May 2007 23:13:25 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: (1 loop device) Re: [1/3] 2.6.22-rc1: known regressions v2
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070516211146.GA5660@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464B6A22.905@googlemail.com>
	 <20070516211146.GA5660@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Uwe to CC]

On 16/05/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Wed, May 16, 2007 at 10:31:30PM +0200, Michal Piotrowski wrote:
> > Block devices
> >
> > Subject    : loop devices limited to one single device
> > References : http://lkml.org/lkml/2007/5/16/229
> > Submitter  : Uwe Bugla <uwe.bugla@gmx.de>
> > Status     : Unknown
>
> >> The patch against loop.c is neither a fix, nor does it create
> >> loop devices on demand:
>
> It does. In kernel memory.
>
> >> Facts are instead, at least on my machine:
>
> >> The number of available loop devices is reduced from 8 (conventional
> >> standard of preceding 2.6 kernels) to 1.
>
> >> The consequence is: If you have to mount more than one single iso-image
> >> with
> >> the loop parameter you are receiving the following message during system
> >> boot:
>
> >> "mount: could not find any free loop device"
>
> I suggest to read mknod(1) manpage.
>
>


-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
