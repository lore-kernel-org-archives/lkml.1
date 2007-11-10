Return-Path: <linux-kernel-owner+w=401wt.eu-S1763936AbXKJDxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763936AbXKJDxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbXKJDw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:52:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:44100 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759562AbXKJDw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:52:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C9tmbW+MYtkUOlJA+aiA/Q+q2bX893wGIax+JypKCTisCT6u53xrrxiZ9m3iviKHwKKhXXmL3VCSkpqeftNFz/W4JQMCwj+euqjxuCEvHvVoi9jy4FyrA/4tLNyjIx8pdV5SxVpL42HSaPtRijYUi+SAQzSIs1bawvODWQuqkcU=
Message-ID: <8bd0f97a0711091952l6a5139caw13b0630c21c5446a@mail.gmail.com>
Date: Fri, 9 Nov 2007 22:52:55 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 2/5] Watchdog: bfin_wdt, remove SPIN_LOCK_UNLOCKED
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Wim Van Sebroeck" <wim@iguana.be>, michael.frysinger@analog.com
In-Reply-To: <7981323273222714582@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4827138842526222333@pripojeni.net>
	 <7981323273222714582@pripojeni.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 9, 2007 6:32 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> bfin_wdt, remove SPIN_LOCK_UNLOCKED
>
> SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

thanks

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
-mike
