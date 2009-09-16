Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZIPBnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZIPBnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZIPBnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:43:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200AbZIPBnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:43:08 -0400
Date: Tue, 15 Sep 2009 18:42:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.32 -mm merge plans (cgroups)
Message-Id: <20090915184237.13160e2a.akpm@linux-foundation.org>
In-Reply-To: <6599ad830909151740n2affe0daw27618ccae9c737d6@mail.gmail.com>
References: <6599ad830909151740n2affe0daw27618ccae9c737d6@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 17:40:15 -0700 Paul Menage <menage@google.com> wrote:

> How much longer is the merge window open for?

A week.

> It's probably safest to
> hold these in -mm for now since we've not resolved the potential races
> in the signal handler accesses; I'll try to find some time to work on
> them this week or next.

It's not a great time to be fixing these things up.

What would happen if we merged it as-is?  Can we be confident that the
resulting bugs won't impact others and that we can get them all fixed
up reasonably promptly?

