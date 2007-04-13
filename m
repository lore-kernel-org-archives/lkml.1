Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXDMUQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXDMUQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965013AbXDMUQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:16:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:58320 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988AbXDMUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O/CdEbgbVN4nzS+RzwSgP7neBCmThRY0wzp6o32C7hEBlGvtl35HfPZtp9wDZEcsHV0+c5GnE83h1tiyLwEj4ntTNGY6jzd8o6r07W4jhj6c1GdKyPXf6ZAxlzJ3wix1oTsh80qurSy3RXGIKlvissZZsiiITYu7o+pbXEqOkpY=
Message-ID: <d120d5000704131315m7b062ca3rd648f27236ae970c@mail.gmail.com>
Date: Fri, 13 Apr 2007 16:15:59 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Dave Jones" <davej@redhat.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: i8042 lockdep false positive.
In-Reply-To: <20070413200202.GC27682@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070413191415.GA27682@redhat.com>
	 <d120d5000704131218x4e0485d7vbc290d1821a65ca3@mail.gmail.com>
	 <20070413200202.GC27682@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/07, Dave Jones <davej@redhat.com> wrote:
> On Fri, Apr 13, 2007 at 03:18:32PM -0400, Dmitry Torokhov wrote:
>  > Hi Dave,
>  >
>  > On 4/13/07, Dave Jones <davej@redhat.com> wrote:
>  > > I just had a user file the report below, which iirc, was deemed a false
>  > > positive.  Didn't we add something to the code so that lockdep would
>  > > ignore what this was doing ?  Did we regress?
>  > >
>  >
>  > For some reasn lockdep annotations cease to work when you reload
>  > psmouse module. I did not have time to look further.
>
> In the case reported, psmouse was non-modular.
>

OK, I was not precise. Every time we destroy and re-create passthrough
port lockdep starts bitching. For some reason annotation works only
once.

I am more quirious why synaptics could not simply reconnect upon
resume and went into full-blown cleanup/find driver/connect cycle...

-- 
Dmitry
