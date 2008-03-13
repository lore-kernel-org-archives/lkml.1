Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYCMTSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYCMTSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYCMTSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:18:36 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:63134 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYCMTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:18:35 -0400
Message-ID: <47D97DF7.8000702@alcatel-lucent.com>
Date: Thu, 13 Mar 2008 14:18:15 -0500
From: Nebojsa Miljanovic <neb@alcatel-lucent.com>
Organization: Lucent Technologies
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.0.1) Gecko/20020823 Netscape/7.0 (CK-LucentTPES)
X-Accept-Language: sr, hr, en, zh, zh-cn, zh-hk, z
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org,
       "Kittlitz, Edward (Ned)" <nkittlitz@alcatel-lucent.com>,
       asweeney@alcatel-lucent.com,
       "Polhemus, William (Bart)" <bpolhemus@alcatel-lucent.com>
Subject: Re: SO_REUSEADDR not allowing server and client to use same port
References: <47C6FA2A.5030302@alcatel-lucent.com> <20080228201926.558c4e7c@core>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,
I would appreciate it if you could elaborate on the security issue. Can you
describe the simultaneous connect scenario?

We have a system we are migrating to Linux from Lynx. We have always had the
ability to re-use ports. We are wondering if this security issue is something we
should take seriously. Or, maybe it is not likely to be seen with our system
running well defined set of applications (i.e. not a PC where anybody could run
anything).

Thanks,
Neb


On 2/28/2008 2:19 PM, Alan Cox wrote:
>>Currently, Linux does not allow reuse of same local port for both TCP server and
>>TCP client. I understand that there may be a need to prevent two servers from
> 
> 
> Think about what happens for simultaneous connect (that obscure little
> corner of the tcp/ip spec). Now think about what it means for security.
> 
> ALan


