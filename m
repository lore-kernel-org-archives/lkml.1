Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbXK0U3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbXK0U3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbXK0U3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:29:30 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49095 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755283AbXK0U33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:29:29 -0500
To: jdike@addtoit.com
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <20071127201105.GA9332@c2.user-mode-linux.org> (message from Jeff
	Dike on Tue, 27 Nov 2007 15:11:05 -0500)
Subject: Re: [uml-devel] leak in do_ubd_request
References: <E1Ix3Du-0002aL-Ac@dorka.pomaz.szeredi.hu> <E1Ix58o-0004J5-Mz@dorka.pomaz.szeredi.hu> <20071127201105.GA9332@c2.user-mode-linux.org>
Message-Id: <E1Ix73b-0004aI-Px@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Nov 2007 21:29:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Nov 27, 2007 at 07:26:38PM +0100, Miklos Szeredi wrote:
> > +				kfree(io_req);
> 
> Whoops, nice catch.
> 
> Can you sign that off for me?

Sure.  The patch works for me, but please check that it also makes
sense.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
