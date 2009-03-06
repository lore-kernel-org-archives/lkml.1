Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZCGABL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZCGABL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 19:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZCGAAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 19:00:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594AbZCGAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:00:54 -0500
Date: Fri, 6 Mar 2009 15:59:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       mchehab@infradead.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -next] dvb/frontends: fix duplicate 'debug' symbol
Message-Id: <20090306155958.11b4a186.akpm@linux-foundation.org>
In-Reply-To: <49B1949E.2000300@oracle.com>
References: <20090306191311.697e7b97.sfr@canb.auug.org.au>
	<49B1949E.2000300@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Mar 2009 13:24:46 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> It would also be Good if arch/x86/kernel/entry_32.S didn't have a
> non-static 'debug' symbol.  OTOH, it helps catch things like this one.

heh, yes, it's a feature.  We should put it in init/main.c, along with
100-odd other dont-do-that-dopey symbols.



