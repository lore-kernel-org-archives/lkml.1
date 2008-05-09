Return-Path: <linux-kernel-owner+w=401wt.eu-S1762420AbYEIP6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762420AbYEIP6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYEIP6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:58:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41428 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbYEIP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:58:20 -0400
To: bfields@fieldses.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080509155040.GB798@fieldses.org> (bfields@fieldses.org)
Subject: Re: [patch 0/9] file locking fixes + fuse nfs export support
References: <20080509124107.645600519@szeredi.hu> <20080509155040.GB798@fieldses.org>
Message-Id: <E1JuUyz-0002GT-Hn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 09 May 2008 17:58:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A separate question--does the problem you reported with interrupted lock
> requests still exist?

No, that bug seems to have gone away in 2.6.26-rc1.  Don't know how,
since the 2.6.25 + nfs.git was still bad.

Should I bisect it to see which patch solved it? ;)

Miklos
