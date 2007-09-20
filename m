Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbXITUWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbXITUWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXITUWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:22:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbXITUWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:22:43 -0400
Date: Thu, 20 Sep 2007 13:22:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] increase AT_VECTOR_SIZE to terminate saved_auxv
 properly
Message-Id: <20070920132240.b1258735.akpm@linux-foundation.org>
In-Reply-To: <20070920191944.GA14348@aepfle.de>
References: <20070914110057.GA10088@aepfle.de>
	<20070918115504.GA609@aepfle.de>
	<20070919234411.d5bf33ea.akpm@linux-foundation.org>
	<20070920191944.GA14348@aepfle.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 21:19:44 +0200
Olaf Hering <olaf@aepfle.de> wrote:

> On Wed, Sep 19, Andrew Morton wrote:
> 
> > I'm not very confident that this will work well with the
> > already-queued move-mm_struct-and-vm_area_struct.patch.
> 
> You want me to redo my patch agains the current -mm kernel?

Would be appreciated, thanks.  If there are any problems then they'll
probably be build-time ones only, but they could be substantial ones -
refactoring our crappy header files always hurts.


