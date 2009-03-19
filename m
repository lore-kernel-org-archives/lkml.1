Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbZCSPfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbZCSPfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZCSPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:35:41 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:55801 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbZCSPfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:35:40 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: Q: NFSD readdir in linux-2.6.28 
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1237475837.16359.106.camel@macbook.infradead.org>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org>
Date: Fri, 20 Mar 2009 00:34:50 +0900
Message-ID: <8913.1237476890@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Woodhouse:
> Yes, well spotted. It didn't matter when the buffered readdir() was
> purely internal to XFS, because it didn't matter there that we called
> ->lookup() without i_mutex set. But now we're exposing arbitrary file
> systems to it, we need to make sure we follow the locking rules. 
> 
> I _think_ it's sufficient to make the affected callers of
> lookup_one_len() lock the parent's i_mutex for themselves before calling
> it. I'll take a closer look...

If you remember why you discarded the FS_NO_LOOKUP_IN_READDIR flag
approach, please let me know. URL or something is enough.

Thanx
J. R. Okajima
