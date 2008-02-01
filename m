Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbYBAX6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbYBAX6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbYBAX6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:58:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbYBAX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:58:33 -0500
Date: Fri, 1 Feb 2008 15:58:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] Split list.h and move rcu-protected lists into
 rculist.h
Message-Id: <20080201155826.a2d308c1.akpm@linux-foundation.org>
In-Reply-To: <478FBEEA.6040000@gmail.com>
References: <478FBEA0.9090203@gmail.com>
	<478FBEEA.6040000@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 21:47:38 +0100
Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:

> This patch moves rcu-protected lists from list.h into a new header
> file rculist.h.

I'm getting way too many compilation errors from this, perhaps because of
new rcu-list usages which weren't present in the old tree (ie: current
Linus mainline) which you tested it against.

The most practical way to prepare a patch like this is to either make it
back-compatible (for a while at least) or to prepare and carefully test it
against latest -mm.  That way you'll pick up everyone's new code.

