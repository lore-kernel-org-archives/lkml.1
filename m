Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZDIC00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZDIC00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 22:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZDIC0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 22:26:13 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:54387 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZDIC0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 22:26:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kxvT9Qczl4QhysB9pFk9gwx2skgu00i1JNBAfSeDp/CrzjxQazGp42pzZsT1FkcWta
         uqHkzBBpd1h/Oyqmu9Ffy06b+W4voQYZl8pi+Wn2l8NTfeIbMk1LfPdQGq/Z7+VvAgt7
         DYr+jMKBl1uH6g3wtYgMQTVffj+44KnefDbcA=
MIME-Version: 1.0
In-Reply-To: <75761e1f53ed07c43a977d98b54d6467d8896530.1239165870.git.tony@bakeyournoodle.com>
References: <75761e1f53ed07c43a977d98b54d6467d8896530.1239165870.git.tony@bakeyournoodle.com>
Date: Wed, 8 Apr 2009 19:26:08 -0700
X-Google-Sender-Auth: 5ed2f16a7ae150da
Message-ID: <9929d2390904081926m6176d705y481085318a930087@mail.gmail.com>
Subject: Re: [E1000-devel] [PATCH] Be explict with what we are !'ing in 
	ixgbe_sfp_config_module_task()
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 9:44 PM, Tony Breeds <tony@bakeyournoodle.com> wrote:
> GCC warns:
> drivers/net/ixgbe/ixgbe_main.c: In function 'ixgbe_sfp_config_module_task':
> drivers/net/ixgbe/ixgbe_main.c:3920: warning: suggest parentheses around operand of '!' or change '&' to '&&' or '!' to '~'
>
> Which I think is right.  Bracket to remove ambiguity.
>
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> ---

Thanks, I will add it to my queue of ixgbe patches.
Remember to CC netdev mailing list for networking patches.

-- 
Cheers,
Jeff
