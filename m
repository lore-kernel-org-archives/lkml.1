Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYKBSdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYKBSdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYKBSdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:33:06 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:11374 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbYKBSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:33:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bh6tAMYA6IXjX0Aj7iRR4oxtUG99F1W//HBS/xVIWU85YTqxVbZVQOphew2J2TnRqB
         EkKjScelBhIEqA4P9ZcweR9wlUtcI9K+QNfLSoGhbV/1JQT5c55XpxsHJhxXGpamY/q2
         zncGKAcer9nYTPTt8SR5kTrQrIr3lcHZZt9vI=
Message-ID: <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com>
Date: Sun, 2 Nov 2008 19:33:00 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: epoll behaviour after running out of descriptors
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>
	 <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 7:25 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> A bug? For starters, epoll_wait does NOT create new files, so no EMFILE
> can come out from there.

It's accept that returns EMFILE.

> You are saturating the port space, and your whole code logic is rather (at
> least) buggy. Try a `netstat -n -t | grep TIME_WAIT | wc -l`

What makes you think I'm saturating the port space?
That space is way bigger than 1 k AFAIK.

EMFILE The per-process limit of open file descriptors has been reached.

And what part of my code logic is buggy?

Olaf
