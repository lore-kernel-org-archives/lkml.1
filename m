Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458Ab0A0PjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0A0PjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390Ab0A0PjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:39:18 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:33157 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0A0PjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:39:17 -0500
MIME-Version: 1.0
X-Originating-IP: [66.187.234.200]
In-Reply-To: <aacba7e1001261621v6abb4270i996a28d19c9f7d7@mail.gmail.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
	 <72dbd3151001261251s606ebf00h86c2ce63293305b6@mail.gmail.com>
	 <aacba7e1001261621v6abb4270i996a28d19c9f7d7@mail.gmail.com>
Date: Wed, 27 Jan 2010 10:39:16 -0500
Message-ID: <be3a4a1001270739u2c0cecfevd87269d947ff7dc0@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Jarod Wilson <jarod@wilsonet.com>
To: Vishal Rao <vishalrao@gmail.com>
Cc: David Rees <drees76@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 7:21 PM, Vishal Rao <vishalrao@gmail.com> wrote:
> 2010/1/27 David Rees <drees76@gmail.com>:
>> Have there been any other reports of NCQ issues with similar Crucial
>> drives or Indilinx?
>
> I haven't personally seen reports of NCQ specific issues. I have seen
> people (online) reporting "issues" with Linux distro installations
> hanging/freezing etc. and some prior attempts at SMART fixes which
> I also initially tried but did not work for me.
>
> I have tried to "publicise" this issue (forum, blog, mailing list posts)
> in the hope more users may search and identify the correct issue
> so that it may be better verified.
>
> Unfortunately, the Crucial ID string is not model-agnostic (if thats
> the right term)... meaning the patch has 3 lines to ID the 3 current
> models that I know of including my own 128 GB model.
>
> Not sure if there's a better, more generic way to match a whole group
> of SSDs (same model family or various vendors) which trigger NCQ errors?

How to define a group gets... Messy. Just as a data point, my own
Barefoot-based SSD, an OCZ Vertex, has no NCQ-related problems
whatsoever, so far as I know. Its currently hooked to a Zotac ION
board, which has ahci-driven sata controllers of some sort, was
previously in a Dell Studio Hybrid, where it also worked just fine.

-- 
Jarod Wilson
jarod@wilsonet.com
