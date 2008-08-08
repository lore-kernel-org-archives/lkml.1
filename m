Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbYHHVBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbYHHVBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760082AbYHHVBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:01:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbYHHVBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:01:11 -0400
Date: Fri, 8 Aug 2008 14:00:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 0/3] matroxfb fixes and improvements
Message-Id: <20080808140019.32d949f7.akpm@linux-foundation.org>
In-Reply-To: <20080808164937.141a95e0@hyperion.delvare>
References: <20080808164937.141a95e0@hyperion.delvare>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 16:49:37 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> Not having heard of Petr in one month and a half, I am sending these 3
> patches again. Patch 1/3 (matrox maven: Fix a broken error path) in
> particular should be applied ASAP. Patch 2/3 (matroxfb: i2c structure
> templates clean-up) would be good to have as well and I tested it.
> Patch 3/3 (matrox maven: Convert to a new-style i2c driver) needs
> testing before it can go upstream. I can't test it myself, but it has
> been in linux-next for 6 weeks or so.

I'll put all three into 2.6.27.

I suspect that #1 should be backported to 2.6.25.x and to 2.6.26.x but
I am unsure about that due to its poor changelogging.

I _think_ that the machine will crash if the i2c_attach_client() or
maven_init_client() calls fail.  But I don't know under what
circumstances that can happen, nor whether the bug has been reported in
the field, etc.

And the -stable people also will be interested in such information when
making their decisions.

