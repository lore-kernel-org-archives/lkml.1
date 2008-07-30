Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbYG3LhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbYG3LhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYG3LhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:37:11 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:37558 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbYG3LhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:37:09 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: 463 kernel developers missing!
To: Jon Smirl <jonsmirl@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Simon Arlott <simon@fire.lp0.eu>,
       lkml <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 30 Jul 2008 13:41:02 +0200
References: <aUEyc-iW-5@gated-at.bofh.it> <aUFum-2wO-19@gated-at.bofh.it> <aUFE5-2PN-29@gated-at.bofh.it> <aUFNF-33Z-13@gated-at.bofh.it> <aUGgE-4dW-3@gated-at.bofh.it> <aUHwg-6IQ-13@gated-at.bofh.it> <aUHZh-7my-17@gated-at.bofh.it> <aUIsm-ej-21@gated-at.bofh.it> <aUJ4P-1xe-7@gated-at.bofh.it> <aUKDI-4oQ-21@gated-at.bofh.it> <aUL6P-5f2-19@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KOA3D-0001ZX-03@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl <jonsmirl@gmail.com> wrote:

> Are the tools case sensitive or insensitive on email addresses? Some
> are are some aren't, so I need these cases...
> Al Viro <viro@zeniv.linux.org.uk>
> Al Viro <viro@zenIV.linux.org.uk>
> Al Viro <viro@ZenIV.linux.org.uk>

Domain names are case-insensitive, local parts may be case sensitive.
You can lowercase all domains and the localparts of some known domains.

> Another problem is internal machine names...
> David S. Miller <davem@sunset.davemloft.net>
> David S. Miller <davem@davemloft.net>

If it's a common problem, you should have a function doing
$domain =~ s/.*\.davemloft\.net$/davemloft.net/; (not that simple, off cause)

