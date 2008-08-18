Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbYHRVpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbYHRVpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYHRVpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:45:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbYHRVpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:45:15 -0400
Date: Mon, 18 Aug 2008 14:44:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [PATCH 1/3] Char: cyclades, remove bogus iomap
Message-Id: <20080818144438.e3eab97a.akpm@linux-foundation.org>
In-Reply-To: <1218731154-32692-1-git-send-email-jirislaby@gmail.com>
References: <1218731154-32692-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 18:25:52 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> readl/writel are not expected to accept iomap return value. Replace
> bogus mapping by standard ioremap.

Confused.  What's wrong with doing readl(pci_iomap(...))?  There are a
fair number of drivers doing this..

