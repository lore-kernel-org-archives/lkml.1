Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930Ab0A0AVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0A0AVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671Ab0A0AVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:21:20 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41112 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0A0AVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Mib8ns7D4bWuYIF2Nvip+s0eMlhIwuBtXAzW/z59IGpu0BPwl/d80Kp9Dk7CHk3B0B
         ti87wjSEVZncmGX920jDoL//xycCtOCDWdfmiN7pf5iR3VDbbMP2REMLo36yK36eFD0z
         a9PwwKU01cR5RqH+iKfGJfDmzEEJdY0viyfuc=
MIME-Version: 1.0
In-Reply-To: <72dbd3151001261251s606ebf00h86c2ce63293305b6@mail.gmail.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
	 <72dbd3151001261251s606ebf00h86c2ce63293305b6@mail.gmail.com>
Date: Wed, 27 Jan 2010 05:51:17 +0530
Message-ID: <aacba7e1001261621v6abb4270i996a28d19c9f7d7@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Vishal Rao <vishalrao@gmail.com>
To: David Rees <drees76@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/27 David Rees <drees76@gmail.com>:
> Have there been any other reports of NCQ issues with similar Crucial
> drives or Indilinx?

I haven't personally seen reports of NCQ specific issues. I have seen
people (online) reporting "issues" with Linux distro installations
hanging/freezing etc. and some prior attempts at SMART fixes which
I also initially tried but did not work for me.

I have tried to "publicise" this issue (forum, blog, mailing list posts)
in the hope more users may search and identify the correct issue
so that it may be better verified.

Unfortunately, the Crucial ID string is not model-agnostic (if thats
the right term)... meaning the patch has 3 lines to ID the 3 current
models that I know of including my own 128 GB model.

Not sure if there's a better, more generic way to match a whole group
of SSDs (same model family or various vendors) which trigger NCQ errors?

-- 
"Thou shalt not follow the null pointer for at its end madness and chaos lie."
