Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbYGOVo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbYGOVo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbYGOVor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:44:47 -0400
Received: from mail2.shareable.org ([80.68.89.115]:53704 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYGOVoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:44:46 -0400
Date: Tue, 15 Jul 2008 22:44:42 +0100
From: Jamie Lokier <jamie@shareable.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
Message-ID: <20080715214442.GA9222@shareable.org>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net> <20080715195333.GK21590@fieldses.org> <Pine.LNX.4.64.0807151326130.1976@cobra.newdream.net> <20080715204812.GD25803@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715204812.GD25803@fieldses.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> I just wonder how one would explain to users (or application writers)
> why changes to a file are reflected in the parent's rctime in one case,
> and not in another, especially if the primary link is otherwise
> indistinguishable from the others.  The symptoms could be a bit
> mysterious from their point of view.

Btw, what happens when the primary link is deleted?  Does another link
become the primary link?

-- Jamie
