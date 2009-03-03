Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZCCIbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZCCIbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZCCIa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:30:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbZCCIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:30:55 -0500
Date: Tue, 3 Mar 2009 00:29:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add to_delayed_work macro
Message-Id: <20090303002952.80f1afc8.akpm@linux-foundation.org>
In-Reply-To: <20090303083440.57df68c3@hyperion.delvare>
References: <20090303083440.57df68c3@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009 08:34:40 +0100 Jean Delvare <khali@linux-fr.org> wrote:

> +#define to_delayed_work(_work)	container_of(_work, struct delayed_work, work)

As this is specifically designed to operate on a `struct work*', as
opposed to "any struct which has a field called `work'", we can get
additional type-safety by putting a C interface around it.

