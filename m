Return-Path: <linux-kernel-owner+w=401wt.eu-S965673AbXCGVaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbXCGVaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965672AbXCGVaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:30:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:29041 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965671AbXCGVad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:30:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GNLP9P++1A2xn/P9eaRc/41rgJw5kVQ1Oec6c+4wlj2a07z7ha6fqicF9FGJ2zUkt8imedmsh+kyMdPvHYVvetTYot+7AaH05I32grhZTDs/4lTmY3QG+ljIEYR7x3J+MdgpOeF/Znl92PDstLMaIpLzPn8g8C2NGLCLe4Zc6dE=
Message-ID: <57354eff0703071330k2395e9c8n58e12f2111dcb25a@mail.gmail.com>
Date: Wed, 7 Mar 2007 22:30:31 +0100
From: "Oleksiy Kebkal" <kebkal@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Mike Frysinger" <vapier.adi@gmail.com>, rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
In-Reply-To: <200703071019.55896.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
	 <200703061824.08834.rgetz@blackfin.uclinux.org>
	 <m3irddusp0.fsf@maximus.localdomain>
	 <200703071019.55896.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/7, Robin Getz <rgetz@blackfin.uclinux.org>:
> Right - so the question is where to manage the default state? I was thinking
> in the resource might be a good idea, but there isn't really a good place for
> it. (You could re-use some bits if flags, but I think that would not be a
> good idea).

/proc/tty/driver/uartN/settings?

-Oleksiy
