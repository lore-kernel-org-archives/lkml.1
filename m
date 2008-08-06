Return-Path: <linux-kernel-owner+w=401wt.eu-S1763656AbYHFJgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656AbYHFJgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbYHFJfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:35:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:15730 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbYHFJfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n5Lvrd0NfQf2kb2J38J+Ubp6e5sIx7TwJ7L6tdtM6LiroQx3hgML+PNHv8fUXizYPJ
         jLjtjYIilUiGHqWaLJtKQCZf+nwfKLLZIe3aS/FmnhaFEczvHFPrRNOsQghsve9QqoZG
         duK0R5avkaw3QIsVk/kvMoiyxvwvxe1S6dtco=
Message-ID: <b6a2187b0808060235v52e6035agb11c10997d0fe2f8@mail.gmail.com>
Date: Wed, 6 Aug 2008 17:35:51 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440808060149s697fe9p43f0be72d464f75e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <20080805.221917.42858161.davem@davemloft.net>
	 <b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
	 <86802c440808060149s697fe9p43f0be72d464f75e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 4:49 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> do you have
>
> CONFIG_X86_GENERICARCH=y
> CONFIG_X86_BIGSMP=y
>
> 8 more cpu need bigsmp mode.


Are these the ones that supposed to be set? Any, can't find a place to
set these using menuconfig.

# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set

Thanks
Jeff.
