Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbXJXSa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbXJXSa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbXJXSau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:30:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:29036 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbXJXSas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DGEct9J6V1XO71iNv2vLvZlt76cq0SXPwqeAGXOPMW9NC5T5lRJWLBMg88oo9vEmr4+AkzlQdDfKaTBzfFAG6sip2mS9PIXQYzHR6IB00psW9aUhx7fLcCgIckHwNmJ8PZ1x80QCOpvaCEuG3eKiTlqumxGFL7GXvoLSyfJ86hs=
Message-ID: <b79f23070710241130r4608128y99f5372d095a49ee@mail.gmail.com>
Date: Wed, 24 Oct 2007 11:30:46 -0700
From: "James Ausmus" <james.ausmus@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Possible 2.6.23 regression - Disappearing disk space
In-Reply-To: <471F8E10.3090403@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471F8E10.3090403@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> James Ausmus wrote:
>
> > As a note - when I first see the issue, I have exactly 0 free space
> > available on root, as per df - I then delete some random things in
> > order to have enough free space to operate, which is why in my first
> > df you see 55M available
>
> Perhaps some program still uses some (deleted) files.
>
> Here's how you can achieve a similar effect manually:
>
> # dd if=/dev/zero of=/file
>
> And on another terminal:
>
> # rm -f /file
>
>
> Now watch your space decreasing with "df -h", although "the file was
> deleted". Was it really?
>
> # lsof -n|grep /file
> dd         6406       root    1w      REG        8,1  807791616
> 45 /file (deleted)
>
>
>
> That said, you might want to use lsof and search for "deleted" before
> concluding any further.


Thanks for the tip - I'll do that the next time the issue occurs and
post my results.

-James

>
>
> --
> Tomasz Chmielewski
> http://wpkg.org
>
