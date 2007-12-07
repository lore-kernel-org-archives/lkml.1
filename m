Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbXLGWWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbXLGWWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbXLGWW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:22:28 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:5341 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbXLGWW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=aXKEIwPnRZpuwJGvlwJgDIfJcyfwzfN7hFuqdpQOHihdduDhDFB/GFtgT6uDoyK1wPfzC5cntMkqymxSFOIq8cHPcBIen6/dvCcgz3WrZ1EITFXKa/F/6rdVkNv4ulVdcyYw+E+EcLMcAs9otS2S8/WRxeB6uQW/dMzFGVOqpqk=
Message-ID: <43e72e890712071422j34ca2338xf98fda661f3c22fc@mail.gmail.com>
Date: Fri, 7 Dec 2007 17:22:24 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: 2.6.24-rc4-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, mickflemm@gmail.com,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <20071207021258.GA12624@darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <20071207021258.GA12624@darkstar.lan>
X-Google-Sender-Auth: 4ef89c208b38a3f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 6, 2007 9:12 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi,
>
> 2.6.24-rc4-mm1 build failed at drivers/net/wireless/ath5k/base.c for some inline functions like this:
> drivers/net/wireless/ath5k/base.c:292: sorry, unimplemented: inlining failed in call to 'ath5k_extend_tsf': function body not available
>
> fix it with adjust the order of inline function body.
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

Thanks Dave. What version of gcc were you using? I haven't run into this.

BTW, nothing new was added in this patch, things were just shifted,
but even that may be copyrightable. Is it fair to assume you are
licensing these changes under the same license the file is in?

For this file we'd usually use:

Changes-licensed-under: 3-clause-BSD

For future reference:

http://linuxwireless.org/en/developers/Documentation/SubmittingPatches#Changes-licensed-undertag

  Luis
