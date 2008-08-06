Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYHFKGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYHFKGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYHFJuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:50:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:16986 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYHFJuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WCjjEvrE557pcm5wgHf84VVXovoNm4TqdqIX7GXmYMP/2ag32C7sZ7qC8no+pMwgoH
         p6C4h+3/y12HuBq7oZGBSWCFs02kRIKwDa9DRjizK3+s2LwtxJ5YvZZnUJyr8v73tnOu
         MwhUo5j0mEmo+Nn4hzTROByfhaFupLfUh+DQ8=
Message-ID: <b6a2187b0808060250p6e21a637kec291ba0707c4fdb@mail.gmail.com>
Date: Wed, 6 Aug 2008 17:50:09 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080806.023638.98202277.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
	 <20080806.001836.135194365.davem@davemloft.net>
	 <b6a2187b0808060233t6bd437edi7e74fa225aaa9d01@mail.gmail.com>
	 <20080806.023638.98202277.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 5:36 PM, David Miller <davem@davemloft.net> wrote:
> From: "Jeff Chua" <jeff.chua.linux@gmail.com>
> Date: Wed, 6 Aug 2008 17:33:07 +0800
>
>> On Wed, Aug 6, 2008 at 3:18 PM, David Miller <davem@davemloft.net> wrote:
>>
>> > You have to turn off CONFIG_PROVE_LOCKING, in fact just turn off
>> > everything in the lock debugging section:
> Maybe edit the ".config" file at the top level of the kernel
> sources and then type "make oldconfig" ?!?!?!

Ok, may be not as bad as I thought. These are not in .config meaning,
they are not set. So, it should ok. I'll test out these two first.

> CONFIG_X86_GENERICARCH=y
> CONFIG_X86_BIGSMP=y

Thanks,
Jeff.
