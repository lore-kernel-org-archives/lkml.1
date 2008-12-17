Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752818AbYLQWLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYLQWLt (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYLQWLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:11:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbYLQWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:11:39 -0500
Date: Wed, 17 Dec 2008 14:09:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: louis.rilling@kerlabs.com, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, swhiteho@redhat.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
 configfs_depend_item()
Message-Id: <20081217140900.4d58c18d.akpm@linux-foundation.org>
In-Reply-To: <20081217220310.GB6372@mail.oracle.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com>
	<1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
	<20081217134020.42da55fc.akpm@linux-foundation.org>
	<20081217220310.GB6372@mail.oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 14:03:10 -0800
Joel Becker <Joel.Becker@oracle.com> wrote:

> > >
> > > [etc]
> > >
> > 
> > Oh dear, what an unpleasant patch.
> > 
> > Peter, can this be saved?
> 
> 	I'd love to see it work within lockdep, but it seems rather
> hard, so that's why I recommended Louis cook up this version.  I see you
> picked it up in -mm.  Do you want me to push it through ocfs2.git?

Please do.  If Peter refuses to save us.
