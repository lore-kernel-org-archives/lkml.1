Return-Path: <linux-kernel-owner+w=401wt.eu-S933885AbYA2Sc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbYA2Sc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758930AbYA2Sco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:32:44 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60145 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbYA2Scn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:32:43 -0500
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <1201626379.28547.142.camel@lappy> (message from Peter Zijlstra
	on Tue, 29 Jan 2008 18:06:19 +0100)
Subject: Re: [patch 0/6] mm: bdi: updates
References: <20080129154900.145303789@szeredi.hu> <1201626379.28547.142.camel@lappy>
Message-Id: <E1JJvGA-00060l-Ja@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 29 Jan 2008 19:32:38 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2008-01-29 at 16:49 +0100, Miklos Szeredi wrote:
> > This is a series from Peter Zijlstra, with various updates by me.  The
> > patchset mostly deals with exporting BDI attributes in sysfs.
> > 
> > Should be in a mergeable state, at least into -mm.
> 
> Thanks for picking these up Miklos!
> 
> While they do not strictly depend upon the /proc/<pid>/mountinfo patch I
> think its good to mention they go hand in hand. The mountinfo file gives
> the information needed to associate a mount with a given bdi for non
> block devices.

More precisely /proc/<pid>/mountinfo is only needed to find mounts for
a given BDI (which might not be a very common scenario), and not the
other way round.

But both patches are useful, and they are even more useful together ;)

Miklos
