Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZBHMaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZBHMaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 07:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZBHMaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 07:30:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:31857 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZBHMaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 07:30:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kcXt3hQWXChQt+8FYWC0wOGh60M/sMiRhnD8GmNq8ucwrT2+WwfK7xcQxUKqouvSi+
         vgwk/hwECkv6DiZw0BBW/YkBpmU3vbS/RHoSWNukgqk9kD3Zj7DI1jocmtGuYj9ptWUK
         KjXACaBDRrF5HRVqyVHXxljUD412FXX1CjHIE=
MIME-Version: 1.0
In-Reply-To: <20090208063516.GA2318@elte.hu>
References: <20090208063516.GA2318@elte.hu>
Date: Sun, 8 Feb 2009 13:30:01 +0100
Message-ID: <8db1092f0902080430y7acdbe74pb5b5d0ee5723afe6@mail.gmail.com>
Subject: Re: [bug] sata detection problem
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/8 Ingo Molnar <mingo@elte.hu>:

[...]

> Look at the weird sda detection. The only _real_ device on this system is the
> ST3320620AS disk which got detected as sdb. But the bogus sda entry crashed the
> (older) OS installation on the box:
>
> [   20.132252] VFS: Cannot open root device "sda3" or unknown-block(0,0)
>
> Find below a successful bootup. Bug is very sporadic. (seems timing related)
>

I had similar problem few months ago, while laptop hangs during DVD
drive detection. Problem occurs very often when CONFIG_HZ_1000 is set,
but never when CONFIG_HZ=300 is set. I reported this, but I hadn't any
response. Also I think, that is timming issue.

http://kerneltrap.org/mailarchive/linux-kernel/2008/8/11/2898134

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
