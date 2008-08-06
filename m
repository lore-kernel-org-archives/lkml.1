Return-Path: <linux-kernel-owner+w=401wt.eu-S1764905AbYHFJmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764905AbYHFJmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbYHFJmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:42:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:15893 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbYHFJmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BA2x17Tv8b3Q8Ks2EraeGePquU+hmSfMJjGrqlr1tKP3wgNaw7LZHDYEkSUuz+UaPo
         YSqEi7OqEYBPIwSkY19thRGFmG0BPYH1RZyWYnRKJ15/xxVRw9pYEfeInIOHLJ036sii
         zkZg84BD46iih+LV1a6LSqUnUoy4yp0RcklSg=
Message-ID: <b6a2187b0808060242m7f9cd2a1yc130c0a1af7eea50@mail.gmail.com>
Date: Wed, 6 Aug 2008 17:42:07 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <b6a2187b0808060235v52e6035agb11c10997d0fe2f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <20080805.221917.42858161.davem@davemloft.net>
	 <b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
	 <86802c440808060149s697fe9p43f0be72d464f75e@mail.gmail.com>
	 <b6a2187b0808060235v52e6035agb11c10997d0fe2f8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 5:35 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Wed, Aug 6, 2008 at 4:49 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> do you have
>> CONFIG_X86_GENERICARCH=y
>> CONFIG_X86_BIGSMP=y
>> 8 more cpu need bigsmp mode.
> Are these the ones that supposed to be set? Any, can't find a place to
> set these using menuconfig.
>
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_VSMP is not set

Sorry, found it. These are not obvious. I had selected
"Subarchitecture Type (PC-compatible)" and could find a place to set
CONFIG_X86_GENERICARCH.

Just found it under " Subarchitecture Type (Generic architecture)",
and then it shows the CONFIG_X86_BIGSMP option.

Ok, compiling and testing now.

Jeff.
