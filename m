Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYGWMkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYGWMkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYGWMj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:39:58 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:47951 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422AbYGWMj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:39:57 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: request for comment: generic kernel interface for malware vendors
To: "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 23 Jul 2008 14:43:09 +0200
References: <aRVce-Em-3@gated-at.bofh.it> <aS7Go-7AK-3@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KLdgU-0001a9-7F@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael C. de Almeida <almeidaraf@gmail.com> wrote:
> Eric Paris wrote:

>> [Kernel support for malware scanners]

> I'm a newbie here, so don't take me too serious. But I don't see why
> that needs a kernel interface, at least from the example on the
> Documentation directory (patch 9). Seems to me you could just use file
> permission to deny or allow the access for a certain file. The only
> thing that would be a little trickier from user-space is to know when a
> given file is read. So, talpa should do only that or you could take
> advantage of preload like trickle does for bandwidth shapping.

How do you ensure that the LD_PRELOAD variable stays intact and will be
honored by all applications - including that commercial one supplying it's
own libc, by suid-binaries and by programs written in a non-libc-language?

