Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbYGOVwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbYGOVwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYGOVv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:51:58 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34841 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbYGOVv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:51:57 -0400
Date: Tue, 15 Jul 2008 14:51:56 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Jamie Lokier <jamie@shareable.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
In-Reply-To: <20080715214442.GA9222@shareable.org>
Message-ID: <Pine.LNX.4.64.0807151446140.1976@cobra.newdream.net>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
 <20080715195333.GK21590@fieldses.org> <Pine.LNX.4.64.0807151326130.1976@cobra.newdream.net>
 <20080715204812.GD25803@fieldses.org> <20080715214442.GA9222@shareable.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Jamie Lokier wrote:
> J. Bruce Fields wrote:
> > I just wonder how one would explain to users (or application writers)
> > why changes to a file are reflected in the parent's rctime in one case,
> > and not in another, especially if the primary link is otherwise
> > indistinguishable from the others.  The symptoms could be a bit
> > mysterious from their point of view.
> 
> Btw, what happens when the primary link is deleted?  Does another link
> become the primary link?

Yeah.  It's initially moved to a hidden directory (along with 
open-but-unlinked files), and then moved back into the hierarchy the next 
time a remote link is used.

sage
