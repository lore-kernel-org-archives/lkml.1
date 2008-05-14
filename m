Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbYENEg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbYENEg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYENEgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:36:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbYENEgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:36:46 -0400
Date: Tue, 13 May 2008 21:36:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] Example use of WARN()
Message-Id: <20080513213606.1a295609.akpm@linux-foundation.org>
In-Reply-To: <20080506232156.159ed493@infradead.org>
References: <20080506232017.247001e0@infradead.org>
	<20080506232113.7f066c26@infradead.org>
	<20080506232156.159ed493@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 23:21:56 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: Example use of WARN()
> 
> now that WARN() exists, we can fold some of the printk's into it

Wanna take a look at mips allnoconfig, please?

lib/kobject.c: In function `kobject_add_internal':
lib/kobject.c:218: error: implicit declaration of function `WARN'

# CONFIG_BUG is not set

