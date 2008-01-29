Return-Path: <linux-kernel-owner+w=401wt.eu-S1765669AbYA2RJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765669AbYA2RJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYA2RJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:09:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYA2RJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:09:36 -0500
Subject: Re: [patch 0/6] mm: bdi: updates
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080129154900.145303789@szeredi.hu>
References: <20080129154900.145303789@szeredi.hu>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 18:06:19 +0100
Message-Id: <1201626379.28547.142.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 16:49 +0100, Miklos Szeredi wrote:
> This is a series from Peter Zijlstra, with various updates by me.  The
> patchset mostly deals with exporting BDI attributes in sysfs.
> 
> Should be in a mergeable state, at least into -mm.

Thanks for picking these up Miklos!

While they do not strictly depend upon the /proc/<pid>/mountinfo patch I
think its good to mention they go hand in hand. The mountinfo file gives
the information needed to associate a mount with a given bdi for non
block devices.


