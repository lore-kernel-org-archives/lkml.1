Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbYKNE5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbYKNE5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYKNE5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:57:31 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:60753 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYKNE5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:57:30 -0500
Date: Fri, 14 Nov 2008 07:57:27 +0300
From: Yuri Tikhonov <yur@emcraft.com>
X-Mailer: The Bat! (v4.0.28.1) Professional
Organization: EmCraft
X-Priority: 3 (Normal)
Message-ID: <1124454405.20081114075727@emcraft.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org, Ilya Yanok <yanok@emcraft.com>,
       Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>,
       <linuxppc-dev@ozlabs.org>
Subject: Re[2]: [PATCH] xsysace: use resource_size_t instead of unsigned long
In-Reply-To: <20081113212121.e7a9f5fe.sfr@canb.auug.org.au>
References: <200811131143.17752.yur@emcraft.com> <20081113212121.e7a9f5fe.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
X-Spam-Score: -4.4 (----)
X-Spam-Report: Spam detection software, running on the system "pacific.emcraft.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Hello Stephen, On Thursday, November 13, 2008 you wrote: >
	Hi Yuri, [...] 
	Content analysis details:   (-4.4 points, 2.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Stephen,

On Thursday, November 13, 2008 you wrote:

> Hi Yuri,

> On Thu, 13 Nov 2008 11:43:17 +0300 Yuri Tikhonov <yur@emcraft.com> wrote:
>>
>> -     dev_dbg(ace->dev, "physaddr=0x%lx irq=%i\n", ace->physaddr, ace->irq);
>> +     dev_dbg(ace->dev, "physaddr=0x%llx irq=%i\n", (u64)ace->physaddr, ace->irq);

> You should cast the physaddr to "unsigned long long" as "u64" is
> "unsigned long" on some architectures.  The same is needed in other
> places as well.

 Thanks for your comment. We'll fix this.

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

