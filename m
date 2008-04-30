Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbYD3SLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbYD3SLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbYD3SLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:11:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757088AbYD3SLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:11:37 -0400
Date: Wed, 30 Apr 2008 11:10:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: den@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [patch, -git] isdn: hysdn_procconf.c build fix
Message-Id: <20080430111052.9c0c8974.akpm@linux-foundation.org>
In-Reply-To: <20080430175740.GA26612@elte.hu>
References: <1207653508.7171.18.camel@iris.sw.ru>
	<1207653576-12640-25-git-send-email-den@openvz.org>
	<20080430175740.GA26612@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 19:57:40 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Ob'grumpy: this file was not even build-tested by any of the parties who 
> turned it into upstream commit ac41cfd19b ("isdn: use non-racy method 
> for proc entries creation").

That's because this stupidity:

config HYSDN
        tristate "Hypercope HYSDN cards (Champ, Ergo, Metro) support (module only)"
        depends on m && PROC_FS && PCI && BROKEN_ON_SMP

breaks allmodconfig coverage testing.
