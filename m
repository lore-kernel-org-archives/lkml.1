Return-Path: <linux-kernel-owner+w=401wt.eu-S966130AbXDJIyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966130AbXDJIyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966124AbXDJIyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:54:13 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51124 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966120AbXDJIyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:54:11 -0400
X-Sasl-enc: exmo3vD2K9hBzVWUxbgP6MHfC/EtubUIpHpSgfQW8XbW 1176195250
Subject: Re: [patch 0/8] unprivileged mount syscall
From: Ian Kent <raven@themaw.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4616D4D4.6020405@zytor.com>
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <4616D4D4.6020405@zytor.com>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 16:52:05 +0800
Message-Id: <1176195125.3476.47.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 16:16 -0700, H. Peter Anvin wrote:
> >>
> >> - users can use bind mounts without having to pre-configure them in
> >>   /etc/fstab
> >>
> 
> This is by far the biggest concern I see.  I think the security 
> implication of allowing anyone to do bind mounts are poorly understood.

And especially so since there is no way for a filesystem module to veto
such requests.

Ian


