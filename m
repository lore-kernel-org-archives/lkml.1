Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYEDWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYEDWJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbYEDWJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:09:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:15615 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbYEDWJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qmzmYnbWVF2U18/uwH5HQ7X9IemGfHfDBhYFCu7VazktUxJypHxOtDDHxlTvRbq8G1+JJptfuPGtNemhA6941/tmMYA5aUPcV12Rw1z/PoXb9iVqpQG9brIr18h3f1aogeSOmX7NSNcSNKNtzkpu6XkqaovZm8fhnhuUOVi+J4Y=
Message-ID: <481E33FA.2060905@gmail.com>
Date: Mon, 05 May 2008 02:08:58 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] remove duplicate definition of sysfs_update_group()
References: <1209910666-7918-1-git-send-email-dmitri.vorobiev@gmail.com>
In-Reply-To: <1209910666-7918-1-git-send-email-dmitri.vorobiev@gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev пишет:
> The stub version of the sysfs_update_group() function is erroneously
> provided twice. This patch removes the redundant definition.
> 

Oops! I did not notice Ingo's fix when I was sending my patch:

http://lkml.org/lkml/2008/5/4/21

In Ingo's version, the changelog entry is much better than mine. Sorry
for the noise.

Dmitri

> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
> ---
>  include/linux/sysfs.h |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 27bad59..7858eac 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -196,12 +196,6 @@ static inline int sysfs_update_group(struct kobject *kobj,
>  	return 0;
>  }
>  
> -static inline int sysfs_update_group(struct kobject *kobj,
> -				const struct attribute_group *grp)
> -{
> -	return 0;
> -}
> -
>  static inline void sysfs_remove_group(struct kobject *kobj,
>  				      const struct attribute_group *grp)
>  {

