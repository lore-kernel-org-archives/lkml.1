Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716Ab0A0QPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0A0QPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147Ab0A0QO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:14:59 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:57134 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0A0QO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=elEafIo9X9fP3fLgIGwHwLv0c9JgkpcS1KAvi6XiQVXpX6ga0W2FkgfbWPn2FuStjK
         gUYrg4jX/ZAwsGVZfpe+yRSRLxkjKAf/TRvg9wZ3f4dvzrhQFZwvt60WRvZNv00bS2Nu
         KVTlO+fsuq3YE93ls9nflVXgGAI6KhGi/6GPo=
MIME-Version: 1.0
In-Reply-To: <be3a4a1001270739u2c0cecfevd87269d947ff7dc0@mail.gmail.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
	 <72dbd3151001261251s606ebf00h86c2ce63293305b6@mail.gmail.com>
	 <aacba7e1001261621v6abb4270i996a28d19c9f7d7@mail.gmail.com>
	 <be3a4a1001270739u2c0cecfevd87269d947ff7dc0@mail.gmail.com>
Date: Wed, 27 Jan 2010 21:44:51 +0530
Message-ID: <aacba7e1001270814s3ebdcc62i39d6ed0efeb194eb@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Vishal Rao <vishalrao@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: David Rees <drees76@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/27 Jarod Wilson <jarod@wilsonet.com>:
> How to define a group gets... Messy. Just as a data point, my own
> Barefoot-based SSD, an OCZ Vertex, has no NCQ-related problems
> whatsoever, so far as I know. Its currently hooked to a Zotac ION
> board, which has ahci-driven sata controllers of some sort, was
> previously in a Dell Studio Hybrid, where it also worked just fine.

Thanks for data point. I'm personally hoping for other Crucial users
specifically.

Is NCQ enabled - if you grep dmesg for ata ?

The kernel already appears to blacklist (disable NCQ for) OCZ
SSD models with firmware version "02.10104".
