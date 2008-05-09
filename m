Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbYEIXKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbYEIXKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 19:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYEIXKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 19:10:11 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:53499 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYEIXKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 19:10:10 -0400
Message-ID: <4824D9CD.4050402@krogh.cc>
Date: Sat, 10 May 2008 01:10:05 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Matheos Worku <Matheos.Worku@Sun.COM>
CC: David Miller <davem@davemloft.net>, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com> <20080507.141521.193714938.davem@davemloft.net> <482498D5.9060008@krogh.cc> <20080509.143229.174354251.davem@davemloft.net> <4824C936.9000103@krogh.cc> <4824CBA1.8040703@sun.com> <4824CCF0.5050302@krogh.cc> <4824D1E1.10007@sun.com> <4824D39B.6040006@sun.com>
In-Reply-To: <4824D39B.6040006@sun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matheos Worku wrote:
>>> Thats a transmit.. from the NFS server to the clients.
>>
> Is MSI/MSI-X enabled on the kernel? I have noticed that it was not 
> enabled on Gutsy-SPARC?

# grep MSI .config
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y

Should that be ok?

-- 
Jesper Krogh
