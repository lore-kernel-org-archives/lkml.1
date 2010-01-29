Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683Ab0A2Ore@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0A2Ore (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231Ab0A2Orc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:47:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39984 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab0A2Ora (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:47:30 -0500
Date: Fri, 29 Jan 2010 14:47:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Derek Atkins <warlord@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re-enabling non-GPL driver access to disk partition information
Message-ID: <20100129144728.GS19799@ZenIV.linux.org.uk>
References: <sjmd40t3slu.fsf@pgpdev.ihtfp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sjmd40t3slu.fsf@pgpdev.ihtfp.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 09:15:09AM -0500, Derek Atkins wrote:

> In particular, there is now no way for a proprietary driver to access
> the gendisk partition array, to enumerate the existing partitions, or to
> get information about existing partitions.  All those interfaces are now
> GPL-Only, (whereas access to the structure members before were perfectly
> legal for non-GPL modules).  But now the partition structure is sitting
> behind the GPL-Only RCU abstraction.

Why the hell does disk driver care about partitioning in the first place?
