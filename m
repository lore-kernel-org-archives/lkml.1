Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYCQNU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYCQNU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 09:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYCQNUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 09:20:13 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:41000 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYCQNUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 09:20:11 -0400
Message-ID: <47DE6F52.6000006@fr.ibm.com>
Date: Mon, 17 Mar 2008 14:17:06 +0100
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       pekkas@netcore.fi, yoshfuji@linux-ipv6.org
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail command
 as non-root
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D98510.60801@imap.cc> <47D9A8DF.30809@fr.ibm.com> <47D9C1F0.6050803@imap.cc> <47DE4B7B.9040504@fr.ibm.com> <47DE6CC7.2000405@imap.cc>
In-Reply-To: <47DE6CC7.2000405@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Daniel Lezcano schrieb:
> 
>> I was not able to reproduce it, but I think I didn't configured 
>> postfix as I should had. What version do you use ?
> 
> It's the one that comes with openSUSE 10.3:
> 
> ts@xenon:~> rpm -q postfix
> postfix-2.4.5-20.2
> 
>> If I may ask you, can you put your postfix configuration file and a 
>> strace -f of your failing command ? on your website, that will help me 
>> a lot to investigate.
> 
> Sure, no problem. You may find them at
> 
> http://gollum.phnxsoft.com/~ts/linux/main.cf
> http://gollum.phnxsoft.com/~ts/linux/strace.log

Thank you very much,  I will try to reproduce it with a simple program.
