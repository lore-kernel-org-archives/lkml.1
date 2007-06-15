Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbXFOOgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbXFOOgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXFOOgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:36:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:53039 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbXFOOgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oiuoVYrQUZ+JwGGuRfS/+PKbH2OEIFY3hfwJ/3F9yX/eovwgDIuBvrWT2O+tJZiz+ZAlEJap00g73oje1I105SfM5g3IlGgUSGAp02eqGq4Rf5d7Wi1PxCp/V27g66wYjp9OQS8+GCfDAg2D1FvjX3oQFuKMAWVVmDEYO8lC3jY=
Message-ID: <9c21eeae0706150736o6c581222oca883161e8062ed2@mail.gmail.com>
Date: Fri, 15 Jun 2007 07:36:07 -0700
From: "David Brown" <dmlb2000@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [GIT PULL] KVM fix for 2.6.22
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <11819006133865-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11819006133865-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Avi Kivity <avi@qumranet.com> wrote:
> Linus,
>
> Please pull from the repository and branch at
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus
>
> to get a fix for a fairly critical bug which allows, under certain conditions,
> guest fpu state to find its way into the host fpu.
>
> Avi Kivity (1):
>       KVM: Prevent guest fpu state from leaking into the host
>
>  drivers/kvm/kvm.h      |    3 +++
>  drivers/kvm/kvm_main.c |   22 ++++++++++++++++++++++
>  drivers/kvm/vmx.c      |   12 +++---------
>  3 files changed, 28 insertions(+), 9 deletions(-)
>

Yes thank you for the fix Avi. btw what version of kvm is in 2.6.22?
the kvm wiki doesn't say.

Thanks,
- David Brown
