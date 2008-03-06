Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYCFAQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYCFAQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYCFAQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:16:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYCFAQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:16:20 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] chroot= as a new kernel parameter
To: Guillaume Chazarain <guichaz@gmail.com>,
       Pawel Plociennik <paplociennik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 06 Mar 2008 01:16:11 +0100
References: <a2zNf-7rl-7@gated-at.bofh.it> <a3k9y-4Cf-35@gated-at.bofh.it> <a3kMn-5Jb-25@gated-at.bofh.it> <a3Wop-6Xn-15@gated-at.bofh.it> <a41Rb-7mN-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JX3mO-0003eX-5W@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18DGTxcCWkW9CisI/BdgAgD3plkO4Ew74xNsQa
 4QWzPLLIiAK5jrYZin9xGfRwq9Di3nMCm/rWYdUdiuNcr71BY7
 cHPeJK4WEHyK/+B5jczRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain <guichaz@gmail.com> wrote:
> On Wed, Mar 5, 2008 at 2:38 PM, Pawel Plociennik <paplociennik@gmail.com>

>>  At last my patch is as simple as possible and it has *only* a *few lines of
>>  the code* and it can be used as *independent* method to various *hundred*
>>  distroes.
> 
> Your method requires a certain kernel, mine does not ;-)

Your method requires to type the whole bible on the command line.

>>   static void run_init_process(char *init_filename)
>>   {
>>  +       if (chroot_str)
>>  +               if (sys_chroot(chroot_str) < 0)
>>  +                       printk(KERN_WARNING "chroot=%s failed\n",
>>  chroot_str); +
> 
> As I said before, this chroot= option can be used for security reason
> instead of testing purpose, and in this case, continuing booting after
> a failed chroot sounds like a security issue.

Even if not, continuing on unknown/bad options is a BAD idea. If I made a
typo in the path, the wrong system would be started, leaving me to choose
between waiting (felt) five minutes until I can shut it down cleanly or
to hard reboot and fsck.

