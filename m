Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYC0Ops@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYC0Ops (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757696AbYC0Opj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:45:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:60109 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498AbYC0Oph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:45:37 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] init()/fini() clean up in the crypto
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@ozlabs.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Thu, 27 Mar 2008 15:40:36 +0100
References: <abRrB-4uZ-1@gated-at.bofh.it> <abRBc-53a-9@gated-at.bofh.it> <abVvc-4cT-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1JetHQ-0000wK-Mk@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18qkPsHHhRozYdDltv6ytFG9KCoXkICKntUatt
 pmkSXdg41T/+fgErkPOEqBdM/oo9wh4iN/asB2cwttmIYZw5na
 EXLbVnQOmYaLu4L3ZVt/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> This patch cleanups the crypto code, replaces the init() and fini()  with the
> <algorithm name>_init/_fini

This part ist OK.

> or init/fini_<algorithm name> (if the 
> <algorithm name>_init/_fini exist)

Having init_foo and foo_init won't be a good thing, will it? I'd start
confusing them.

What about foo_modinit instead?

¢¢

