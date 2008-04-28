Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbYD1Hyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbYD1Hyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764112AbYD1Hy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:54:29 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34060 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbYD1Hy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:54:29 -0400
X-Sasl-enc: c/36ZwRKuE1YFE6K8aTtwCxtchuR0csx1NktuLs4nKcl 1209369267
Subject: Re: [PATCH] autofs4 - use lookup access intent to support
	recursive bind mounts
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1209367536.3243.16.camel@raven.themaw.net>
References: <Pine.LNX.4.64.0804281410160.10684@raven.themaw.net>
	 <20080428062213.GB5882@ZenIV.linux.org.uk>
	 <1209364705.3243.1.camel@raven.themaw.net>
	 <20080428070514.GC5882@ZenIV.linux.org.uk>
	 <1209367536.3243.16.camel@raven.themaw.net>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 15:53:40 +0800
Message-Id: <1209369220.3243.18.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-28 at 15:25 +0800, Ian Kent wrote:
> > ->lookup() and friends are going to stop getting struct nameidata *.
> > ->follow_link() obviously will keep it; ->d_revalidate() should
> > lose the sucker, but we might have to split it in two methods (which
> > is probably what'll be needed in your case).
> 
> Right.

Would it be sensible to use dentry->d_flags for this purpose?
Ian


