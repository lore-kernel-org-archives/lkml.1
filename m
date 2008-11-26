Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYKZVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYKZVsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYKZVsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:48:13 -0500
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:51280 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbYKZVsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:48:12 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Is the change to IDE probing really necessary?
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mel Gorman <mel@csn.ul.ie>,
       petkovbb@gmail.com, sshtylyov@ru.mvista.com,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 26 Nov 2008 22:48:06 +0100
References: <bBM1f-6TS-19@gated-at.bofh.it> <bBOFD-1WX-21@gated-at.bofh.it> <bBOYV-2w9-7@gated-at.bofh.it> <bBSST-7ut-11@gated-at.bofh.it> <bBTFg-8vL-15@gated-at.bofh.it> <bBTOS-dn-3@gated-at.bofh.it> <bBU8c-w0-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1L5SEw-0001dG-F6@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> So I think this is a case of 'I put best steam coal in my car and it
> didn't go'

"... but I was told it would."

I think less or different information (resulting in RTFM) might be more
helpful. Looking at the 2.6.27 code, I'd

- change the default to -1 (unset) and let ide_generic_init print the
  text only if it's -1 (and then set it to the default value)
- change the text to
  compiled_in? "please set ide_generic.probe_mask to use the generic IDE driver"
               "please set probe_mask to probe for more legacy interfaces"
- not print anything if all interfaces are probed by default (non-x86)
- document "don't use this driver if there is a more specific driver"
  next to the probe_mask documentation


