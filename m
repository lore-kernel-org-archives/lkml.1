Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbZAUSJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbZAUSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbZAUSIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:08:41 -0500
Received: from kroah.org ([198.145.64.141]:42456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754871AbZAUSIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:08:40 -0500
Date: Wed, 21 Jan 2009 09:45:58 -0800
From: Greg KH <greg@kroah.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] w35und: merge wbhal_s.h and wbhal_f.h header files
Message-ID: <20090121174558.GE3991@kroah.com>
References: <Pine.LNX.4.64.0901121802480.16815@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0901121802480.16815@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 06:03:13PM +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> No need to keep function definitions separate from the rest so unify wbhal_s.h
> and wbhal_f.h header files.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

I get a build error with this patch applied:

  CC [M]  drivers/staging/winbond/mds.o
In file included from drivers/staging/winbond/mds.c:3:
drivers/staging/winbond/mds_f.h:4:19: error: wbhal.h: No such file or directory
In file included from drivers/staging/winbond/mds_f.h:5,
                 from drivers/staging/winbond/mds.c:3:
drivers/staging/winbond/core.h:23: error: field ‘sHwData’ has incomplete type
In file included from drivers/staging/winbond/mds.c:3:
drivers/staging/winbond/mds_f.h:10: error: expected declaration specifiers or ‘...’ before ‘PT02_DESCRIPTOR’
drivers/staging/winbond/mds_f.h:11: error: expected declaration specifiers or ‘...’ before ‘PDESCRIPTOR’
drivers/staging/winbond/mds_f.h:19: error: expected declaration specifiers or ‘...’ before ‘PDESCRIPTOR’
drivers/staging/winbond/mds_f.h:20: error: expected declaration specifiers or ‘...’ before ‘PDESCRIPTOR’
In file included from drivers/staging/winbond/mds.c:4:


And it goes on...

I'll drop this one from my queue.

thanks,

greg k-h
