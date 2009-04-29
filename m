Return-Path: <linux-kernel-owner+w=401wt.eu-S1751631AbZD2Gup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbZD2Gup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZD2Gug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:50:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbZD2Guf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:50:35 -0400
Date: Tue, 28 Apr 2009 23:46:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] tracing/filters: distinguish between signed and
 unsigned fields
Message-Id: <20090428234645.c1780736.akpm@linux-foundation.org>
In-Reply-To: <1240905893.6416.120.camel@tropicana>
References: <1240905893.6416.120.camel@tropicana>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 03:04:53 -0500 Tom Zanussi <tzanussi@gmail.com> wrote:

> +#define is_signed(t)	(((t)-1) < 0)

geeze that was confusing until I worked out that `t' is supposed to be
the name of a C type.

	is_signed(0) == true!

whee.

Rename it to is_signed_type() or something, please?
