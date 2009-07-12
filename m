Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZGLNUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZGLNUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 09:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZGLNUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 09:20:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZGLNUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 09:20:06 -0400
Subject: Re: [rfc -tip] lib,rb-tree - introduce rb_for_each helper
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090711222928.GD6641@nowhere>
References: <20090711220009.GA16028@lenovo>  <20090711222928.GD6641@nowhere>
Content-Type: text/plain
Date: Sun, 12 Jul 2009 15:20:01 +0200
Message-Id: <1247404801.6733.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-12 at 00:29 +0200, Frederic Weisbecker wrote:
> #define rb_for_each_entry(tpos, pos, root, memb) \
>         for (pos = rb_first(root); pos && tpos = rb_entry(pos, typeof(*tpos), memb); \
>              pos = rb_next(pos->memb, typeof(*pos), memb))

if you really want to do this, then at least call it:
for_each_rb_entry().

