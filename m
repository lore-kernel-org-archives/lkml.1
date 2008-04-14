Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbYDNPPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbYDNPPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbYDNPO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:14:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759621AbYDNPO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:14:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080414141938.GK6695@cs181133002.pp.htv.fi>
References: <20080414141938.GK6695@cs181133002.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mn10300: export kernel_thread
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 14 Apr 2008 16:14:29 +0100
Message-ID: <6713.1208186069@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> +EXPORT_SYMBOL_GPL(kernel_thread);

Please use EXPORT_SYMBOL() to be consistent with the other archs, but apart
from that, it looks fine.

David
