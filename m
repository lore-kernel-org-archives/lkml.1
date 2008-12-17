Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759068AbYLQKcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbYLQKcL (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 05:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYLQKb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 05:31:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40749 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752634AbYLQKbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 05:31:55 -0500
Date: Wed, 17 Dec 2008 10:31:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] fix xconsole.
Message-ID: <20081217103132.65061c05@lxorguk.ukuu.org.uk>
In-Reply-To: <m1wsdz892h.fsf@frodo.ebiederm.org>
References: <m1wsdz892h.fsf@frodo.ebiederm.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The console messages may only be redirected once, and root may perform
> that initial redirection.  So I don't see why it is a security issue.

I see nothing after your change that stops random users redirecting the
console providing they are "first". Random users should not be able to
hijack the system console stream.

The ancient behaviour is an icky hack for xconsole in a world where
security didn't use to matter.

Alan
