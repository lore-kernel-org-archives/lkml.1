Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbXEVX30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbXEVX30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbXEVX3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:29:09 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:61413 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbXEVX3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:29:07 -0400
Message-ID: <46537C27.4050200@cs.columbia.edu>
Date: Tue, 22 May 2007 19:26:31 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Why do we want this?
> --------------------
> 
> That depends on who you ask.  My answer is this:
> 
>   'foo.tar.gz/foo/bar' or
>   'foo.tar.gz/contents/foo/bar'
> 
> or something similar.
> 
> Others might suggest accessing streams, resource forks or extended
> attributes through such an interface.  However this patch only deals
> with the non-directory case, so directories would be excluded from
> that interface.

here's a possibly stupid question.  What about symlinks to dirs?  namely 
the shells tend to treat them differently if postfixed with a slash or not.
