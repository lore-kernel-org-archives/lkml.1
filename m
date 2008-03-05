Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbYCENXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbYCENXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYCENXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:23:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:35810 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYCENXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sGPXu9XFlAHIfik7huAUaepCxkLG+ErVF2PnScp3Getg3wLlJw1niAHb7SMoEVbF/0ujufxkaFgm9AqDKOA81iyvc9k0IYfYdQIjjyWuahuML7xO8etFSvgXfqPYhnTcmbCjSflfkUAU0dTqFgF/2iqkTwhhx3eUFp4V0c8Ailk=
Message-ID: <3d8471ca0803050523r2a55c91em68021a7b078ef48c@mail.gmail.com>
Date: Wed, 5 Mar 2008 14:23:44 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Pawel Plociennik" <paplociennik@gmail.com>
Subject: Re: [PATCH] chroot= as a new kernel parameter
Cc: "Pavel Machek" <pavel@ucw.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <200803050838.03452.paplociennik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803011409.59526.paplociennik@gmail.com>
	 <20080303141203.GB12606@elf.ucw.cz>
	 <3d8471ca0803030719x418f9997tc428344e659a6c90@mail.gmail.com>
	 <200803050838.03452.paplociennik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 2:38 PM, Pawel Plociennik <paplociennik@gmail.com> wrote:
>  At last my patch is as simple as possible and it has *only* a *few lines of the code* and it can be used
>  as *independent* method to various *hundred* distroes.

Your method requires a certain kernel, mine does not ;-)

>   static void run_init_process(char *init_filename)
>   {
>  +       if (chroot_str)
>  +               if (sys_chroot(chroot_str) < 0)
>  +                       printk(KERN_WARNING "chroot=%s failed\n", chroot_str);
>  +

As I said before, this chroot= option can be used for security reason
instead of testing purpose, and in this case, continuing booting after
a failed chroot sounds like a security issue.

-- 
Guillaume
