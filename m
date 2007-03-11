Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbXCKIJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbXCKIJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 04:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbXCKIJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 04:09:54 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39463 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbXCKIJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 04:09:53 -0400
Date: Sun, 11 Mar 2007 00:09:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [RFC PATCH 1/3] Add ability to keep track of callers of
 symbol_(get|put)
Message-Id: <20070311000938.80202418.akpm@linux-foundation.org>
In-Reply-To: <1173501095.26213.405.camel@localhost>
References: <1173501095.26213.405.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 10 Mar 2007 02:31:35 -0200 Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> From: Trent Piepho <xyzzy@speakeasy.org>
> 
> When a module uses symbol_get() to increase the ref count of another
> module, there is no record what module called symbol_get().  A module
> can
> show up as having other users, but there is no way to tell who those
> users are.
> 
> This adds that ability to symbol_put() and symbol_get().

One day I'll write a script which unwordwraps patches and then you'll all
need to find new ways of torturing me.

This patch needed rather a lot of help in the coding-style department. 
Hopefully Rusty can comment on the content, because I'm all exhausted from
cleaning it up.

