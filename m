Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZBJIul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZBJIul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZBJIu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:50:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:64433 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZBJIu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:50:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=IUswJSj/UL25BBVEQSKDQq+Z2/Gp3SsqrGB1mAQGfdQJOH2sXi7biHIwda8rhgZo0q
         eC64fHoMiZ4kMHnqTvSNBBegN8ZNhu0fV+8yARDIwl++5cnqvW2k14ISLSAuhM3T+26E
         m4Rmb/89ijOA9b95/8nv7baMDa776FWKdXVZU=
Date: Tue, 10 Feb 2009 08:50:21 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: roel.kluin@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevice: ticks reaches 25, not 26.
Message-ID: <20090210085021.GB4190@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209.175714.70463534.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-02-2009 02:57, David Miller wrote:
> From: Roel Kluin <roel.kluin@gmail.com>
> Date: Mon, 09 Feb 2009 23:22:11 +0100
> 
>> With while (tick++ < 25) { ... } ticks reaches 25, not 26.
> 
> Does it?
> 
> --------------------
> #include <stdio.h>
> int main(void)
> {
> 	int i = 0;
> 	while (i++ < 25)
> 		;
> 	printf("%d\n", i);
> 
> 	return 0;
> }
> --------------------
> davem@sunset:~/src/GIT/linux-2.6$ gcc -O2 -o x x.c
> davem@sunset:~/src/GIT/linux-2.6$ ./x
> 26
> davem@sunset:~/src/GIT/linux-2.6$ 
> 
> I'm getting extremely tired of these "off by one" patches, to be
> honest with you.

So, what other C feature do you find a better source of joy now?

Jarek P.
