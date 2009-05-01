Return-Path: <linux-kernel-owner+w=401wt.eu-S1763312AbZEAUxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763312AbZEAUxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbZEAUwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:52:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758823AbZEAUwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:52:49 -0400
Date: Fri, 1 May 2009 13:47:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@redhat.com>
Cc: josef@redhat.com, jbacik@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com, stable@kernel.org
Subject: Re: [PATCH] fiemap: fix problem with setting FIEMAP_EXTENT_LAST
Message-Id: <20090501134709.5fda74ba.akpm@linux-foundation.org>
In-Reply-To: <20090501201646.GK7076@unused.rdu.redhat.com>
References: <1241113491-9031-1-git-send-email-jbacik@redhat.com>
	<20090430154047.5485759f.akpm@linux-foundation.org>
	<20090501143517.GF7076@unused.rdu.redhat.com>
	<20090501125043.11da02f3.akpm@linux-foundation.org>
	<20090501201646.GK7076@unused.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 16:16:46 -0400
Josef Bacik <josef@redhat.com> wrote:

> I think this late in the game it's
> probably best to just go with whats already in the kernel for now, and I'll
> rework some of this stuff and work with Eric to get a good test suite set up to
> make sure everything is working properly, and then shoot for -31.  Does that
> sound good?

yup, I agree.
