Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYARBCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYARBCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbYARBCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:02:45 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:11956 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbYARBCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S6k3BPafI/lVIWD5pDa7yPiyby1scW+EDvXfJ8PpuXnGi6kDqjCYpfYe9JS+WrG4jf/F3+feSI1z1DRm3ILK5Dc4tu2Tr5rIVXMoqJrjVGPrRYKMVjPrAa+anBqzR2kS6pPEgd9xWd/BB4LSm5Ryr/Eu6J6pFVPqckmaD6sR7jg=
Message-ID: <5d6222a80801171702v5b4ef40ai67b5febd4d74c470@mail.gmail.com>
Date: Thu, 17 Jan 2008 23:02:42 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Glauber de Oliveira Costa" <gcosta@redhat.com>
Subject: Re: [PATCH 0/7] More lguest massage.
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
In-Reply-To: <12006165841070-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200616550283-git-send-email-gcosta@redhat.com>
	 <12006165571406-git-send-email-gcosta@redhat.com>
	 <1200616561270-git-send-email-gcosta@redhat.com>
	 <12006165651341-git-send-email-gcosta@redhat.com>
	 <12006165701019-git-send-email-gcosta@redhat.com>
	 <12006165743557-git-send-email-gcosta@redhat.com>
	 <12006165781954-git-send-email-gcosta@redhat.com>
	 <12006165841070-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have _any_ idea about what happened to those patches. They
were sent through the normal git-send-email script, but for
some reason, all got the same subject. They might be okay for the
review, but anyone willing to try it more seriously, please grab it
at http://glommer.net/patches-lguest.tar.gz

On Jan 17, 2008 10:35 PM, Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
> urrently, lguest module can't be compiled without the PARAVIRT flag being
> on.This is a fake dependency, since the module itself shouldn't need any
> paravirtoverride. Reason for that is the reference to pv_info structure
> ininitial loading tests.
>
> his patch removes it in favour of a more generic error message.
>
> Signed-off-by:Glauber de Oliveira Costa <gcosta@redhat.com>
> ---
> drivers/lguest/core.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff--git a/drivers/lguest/core.c b/drivers/lguest/core.c
> indexbb42fd0..97b76d6 100644
> ---a/drivers/lguest/core.c
> +++b/drivers/lguest/core.c
> @@-255,7 +255,7 @@ static int __init init(void)
>
>         /* Lguest can't run under Xen, VMI or itself.  It does Tricky Stuff. */
>         if (paravirt_enabled()) {
> -               printk("lguestis afraid of %s\n", pv_info.name);
> +               printk("lguestcan't run under another hypervisor");
>                 return -EPERM;
>         }
>
> --
> 1.5.0.6
>
>



-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
