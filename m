Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZFWVIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZFWVIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZFWVIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:08:06 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56615 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbZFWVIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:08:05 -0400
Date: Tue, 23 Jun 2009 23:10:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/vmlinux.lds.h: Fix up RW_DATA_SECTION definition.
Message-ID: <20090623211025.GA24201@uranus.ravnborg.org>
References: <20090623160435.GC26674@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623160435.GC26674@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 01:04:36AM +0900, Paul Mundt wrote:
> RW_DATA_SECTION is defined to take 4 different alignment parameters,
> while NOSAVE_DATA currently uses a fixed PAGE_SIZE alignment as noted
> in the comments.
> 
> There are presently no in-tree users of this at present, and I just
> stumbled across this while implementing the simplified script on a new
> architecture port, which subsequently resulted in a syntax error.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Thanks - applied.
And I'm glad this is used.

	Sam
