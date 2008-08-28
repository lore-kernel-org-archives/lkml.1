Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYH1TSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYH1TSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYH1TSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:18:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52894 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbYH1TSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:18:25 -0400
To: hpa@kernel.org
CC: tj@kernel.org, fuse-devel@lists.sourceforge.net, miklos@szeredi.hu,
       greg@kroah.com, linux-kernel@vger.kernel.org
In-reply-to: <48B6F7C5.3020204@kernel.org> (hpa@kernel.org)
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <48B6EC83.1070207@kernel.org> <48B6EE36.5070209@kernel.org> <48B6F7C5.3020204@kernel.org>
Message-Id: <E1KYn0U-00047F-Qa@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 28 Aug 2008 21:18:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, H. Peter Anvin wrote:
> Tejun Heo wrote:
> > 
> > Ah.... funky.  If this retry thing is too repulsive, I guess the best
> > alternative would be directly accessing caller's memory as Miklos suggested.
> > 
> 
> Be careful -- there are some serious dragons there in the presence of 
> multiple threads.

OK, it should map /proc/pid/task/tid/mem.  Or rather
/proc/tid/task/tid/mem, as the pid (tgid) of the caller is not
currently passed to the filesystem.

Miklos
