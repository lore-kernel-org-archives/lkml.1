Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYAINsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYAINsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYAINs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:48:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59769
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbYAINs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:48:28 -0500
Date: Wed, 09 Jan 2008 05:48:28 -0800 (PST)
Message-Id: <20080109.054828.24151898.davem@davemloft.net>
To: jikos@jikos.cz
Cc: hch@lst.de, airlied@linux.ie, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de, pq@iki.fi,
       jbeulich@novell.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
 achitectures and kill notifier cruft"
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0801091418510.25041@twin.jikos.cz>
References: <20080109071727.GA10695@lst.de>
	<20080108.232223.211829980.davem@davemloft.net>
	<Pine.LNX.4.64.0801091418510.25041@twin.jikos.cz>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jikos@jikos.cz>
Date: Wed, 9 Jan 2008 14:19:58 +0100 (CET)

> On Tue, 8 Jan 2008, David Miller wrote:
> 
> > You can set a kprobe on the x86 fault handler to do things like
> > mmiotrace.
> 
> Currently, on x86, you can not, because:
> 
> 	fastcall void __kprobes do_page_fault( ... );

Read Ingo's reply.
