Return-Path: <linux-kernel-owner+w=401wt.eu-S1762346AbYENOZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346AbYENOZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYENOZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:25:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43150 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753697AbYENOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:25:17 -0400
Date: Wed, 14 May 2008 15:13:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [1/1] Export __lock_page_killable()
Message-ID: <20080514151356.0cb4abfe@core>
In-Reply-To: <20080514141157.GA27047@2ka.mipt.ru>
References: <20080514141157.GA27047@2ka.mipt.ru>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 18:11:58 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Hi.
> 
> There are users, who would like to use lock_page_killable() in modules,
> so far there are no users in kernel, but for consistency it can be
> exported without them.

Missing information #1: Who are the users and what are the URLs to the
code in question

> Not that it is particulary needed

Humm..

> +EXPORT_SYMBOL(__lock_page_killable);

_GPL - or better yet this could be added *when* we have an actual in tree
user who really needs it and can show it is appropriate to export.
That'll also save Adrian from removing it again ;)
