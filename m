Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbZJOMFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbZJOMFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 08:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762628AbZJOMFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 08:05:18 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:46096 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbZJOMFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 08:05:17 -0400
Message-ID: <4AD70FC2.5050302@ans.pl>
Date: Thu, 15 Oct 2009 14:04:18 +0200
From: =?ISO-8859-2?Q?Krzysztof_Ol=EAdzki?= <ole@ans.pl>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, netfilter-devel@vger.kernel.org
Subject: Re: [Patch] (updated) netfilter: remove deprecated CONFIG_NF_CT_ACCT
References: <20091015080211.4561.78538.sendpatchset@localhost.localdomain>
In-Reply-To: <20091015080211.4561.78538.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend, previously I incorrectly copied netfilter-devel-owner]

Adding CC to netfilter-devel@vger.kernel.org, where netfilter
related issues are discussed.

On Thu, 15 Oct 2009, Amerigo Wang wrote:

>
> CONFIG_NF_CT_ACCT is scheduled to be removed in 2.6.29.
>
> Cc: Krzysztof Piotr Oledzki <ole@ans.pl>
> Signed-off-by: WANG Cong <amwang@redhat.com>

This is not so easy - it was decided that we don't want to remove it 
just that because of connbytes. The final conclusion was to keep it 
disabled by default (if not enabled by kernel/modules/sysctl option) but 
enabling it automatically for the current NS if nefilter rules contains 
"-m connbytes".

Sorry, I should have gotten into this and finished it earlier, my bad. :(

Best regards,

  				Krzysztof Olêdzki
