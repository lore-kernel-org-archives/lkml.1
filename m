Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbYKDUsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbYKDUsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYKDUsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:48:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbYKDUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:48:11 -0500
Date: Tue, 4 Nov 2008 12:47:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: cl@linux-foundation.org, npiggin@suse.de, peterz@infradead.org,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-Id: <20081104124753.fb1dde5a.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 12:23:10 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> This is the revised cpuset writeback throttling patchset

I'm all confused about why this is a cpuset thing rather than a cgroups
thing.  What are the relationships here?

I mean, writeback throttling _should_ operate upon a control group
(more specifically: a memcg), yes?  I guess you're assuming a 1:1
relationship here?

