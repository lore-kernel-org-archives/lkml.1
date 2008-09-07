Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYIGQkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYIGQkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 12:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYIGQjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 12:39:54 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:59821 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbYIGQjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 12:39:52 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception 	- lockdep related?]
To: Ingo Molnar <mingo@elte.hu>, Luca Tettamanti <kronos.it@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Reply-To: 7eggert@gmx.de
Date: Sun, 07 Sep 2008 18:47:33 +0200
References: <b8P0N-3Dp-11@gated-at.bofh.it> <b8PaB-3Or-23@gated-at.bofh.it> <b8Q6x-51x-11@gated-at.bofh.it> <b961C-rW-9@gated-at.bofh.it> <b97qL-26L-15@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KcNQE-0001Le-8P@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> In any case it would make sense to turn that particular overlap
> situation into a warning message and disable initrd decompress - and try
> to boot with whatever is built-in the kernel.

If I explicitely tell my system to load a ramdisk, ignoring it is a bug.

I had a similar bug in PAM: One of these modules has a parameter to invert
the check. I copied the tested configuration to an old debian system, which
did not have this parameter, and it decided to ignore it (as if I were just
joking while writing the config files of a security system). Therefore the
system was open for everybody who was not supposed to use it.

I don't think ignoring an intrd will be as serious, but having a panic (and
a timeout) is preferable to starting the wrong configuration.

