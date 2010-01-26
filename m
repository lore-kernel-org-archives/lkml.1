Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129Ab0AZB63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab0AZB63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560Ab0AZB62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:58:28 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:54197 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0AZB61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:58:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=as8k6Jqwfc2Y+oML5uNVyZJ+2K9Dcep5XrJO6PmGAkf0/uSonbhyw5zES5NAzdw1hR
         fCs0x97MWa4H4c7n9W5aaBFnNTa88cvalklUXp8qCRO/OTBu6uGecB24OB6m0KIaqS0/
         U3JSAdrrf7IT10UjQaUebxU8bQ00fXbJ5I9tM=
MIME-Version: 1.0
In-Reply-To: <20100125161120.74cea0d4.akpm@linux-foundation.org>
References: <1263899593-12178-1-git-send-email-vapier@gentoo.org> 
	<1263899593-12178-3-git-send-email-vapier@gentoo.org> <20100125161120.74cea0d4.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 25 Jan 2010 20:57:57 -0500
Message-ID: <8bd0f97a1001251757p6dd61c85g43b3edcc9f2ce93f@mail.gmail.com>
Subject: Re: [PATCH 3/4] serial: bfin_5xx: kgdboc should accept gdb break only 
	when it is active
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 19:11, Andrew Morton wrote:
> I expect that we want
>
>        [PATCH 2/4] serial: bfin_5xx: need to disable DMA TX interrupt too
> and
>        [PATCH 3/4] serial: bfin_5xx: kgdboc should accept gdb break only when it is active
>
> in 2.6.33 and the other two in 2.6.34?
>
> If so then should either of the above two also be backported into
> -stable?

sounds OK to me, thanks
-mike
