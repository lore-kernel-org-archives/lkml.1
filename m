Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbZAWOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbZAWOWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbZAWOWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:22:37 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53708 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbZAWOWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:22:36 -0500
Subject: Re: [PATCH 2/3] w35und: merge wbhal_s.h and wbhal_f.h header files
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20090121174558.GE3991@kroah.com>
References: <Pine.LNX.4.64.0901121802480.16815@melkki.cs.Helsinki.FI>
	 <20090121174558.GE3991@kroah.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 Jan 2009 16:22:34 +0200
Message-Id: <1232720555.6094.63.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 09:45 -0800, Greg KH wrote:
> On Mon, Jan 12, 2009 at 06:03:13PM +0200, Pekka J Enberg wrote:
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > No need to keep function definitions separate from the rest so unify wbhal_s.h
> > and wbhal_f.h header files.
> > 
> > Cc: Pavel Machek <pavel@suse.cz>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> I get a build error with this patch applied:
> 
>   CC [M]  drivers/staging/winbond/mds.o
> In file included from drivers/staging/winbond/mds.c:3:
> drivers/staging/winbond/mds_f.h:4:19: error: wbhal.h: No such file or directory
> In file included from drivers/staging/winbond/mds_f.h:5,
>                  from drivers/staging/winbond/mds.c:3:
> drivers/staging/winbond/core.h:23: error: field ‘sHwData’ has incomplete type
> In file included from drivers/staging/winbond/mds.c:3:
> drivers/staging/winbond/mds_f.h:10: error: expected declaration specifiers or ‘...’ before ‘PT02_DESCRIPTOR’
> drivers/staging/winbond/mds_f.h:11: error: expected declaration specifiers or ‘...’ before ‘PDESCRIPTOR’
> drivers/staging/winbond/mds_f.h:19: error: expected declaration specifiers or ‘...’ before ‘PDESCRIPTOR’
> drivers/staging/winbond/mds_f.h:20: error: expected declaration specifiers or ‘...’ before ‘PDESCRIPTOR’
> In file included from drivers/staging/winbond/mds.c:4:
> 
> 
> And it goes on...
> 
> I'll drop this one from my queue.

OK, sorry about that. I'll wait for the other patches to land in
mainline and respin that one. Thanks!

			Pekka

