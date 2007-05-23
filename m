Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbXEWGke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbXEWGke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756285AbXEWGkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:40:25 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:53834 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbXEWGkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:40:24 -0400
To: spotter@cs.columbia.edu
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       torvalds@linux-foundation.org
In-reply-to: <46537C27.4050200@cs.columbia.edu> (message from Shaya Potter on
	Tue, 22 May 2007 19:26:31 -0400)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <46537C27.4050200@cs.columbia.edu>
Message-Id: <E1HqkVI-00018I-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 08:39:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Others might suggest accessing streams, resource forks or extended
> > attributes through such an interface.  However this patch only deals
> > with the non-directory case, so directories would be excluded from
> > that interface.
> 
> here's a possibly stupid question.  What about symlinks to dirs?  namely 
> the shells tend to treat them differently if postfixed with a slash or not.

Right.  So it only works on non-directory, non-symlink objects.

Miklos
