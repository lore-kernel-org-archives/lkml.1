Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbYJ0Lid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbYJ0Lid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYJ0LiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:38:11 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45528 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYJ0LiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:38:08 -0400
To: ncunningham@crca.org.au
CC: miklos@szeredi.hu, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1225106427.26724.5.camel@nigel-laptop> (message from Nigel
	Cunningham on Mon, 27 Oct 2008 22:20:27 +1100)
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
References: <1224886068.6478.21.camel@nigel-laptop>
	 <200810262101.08822.rjw@sisk.pl>  <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu> <1225106427.26724.5.camel@nigel-laptop>
Message-Id: <E1KuQPx-0002Yz-7K@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 27 Oct 2008 12:37:53 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Nigel Cunningham wrote:
> It doesn't matter why a process is sitting in that wait_event call. What
> does matter is that one can be there.

Right, but it could also be sleeping in any other wait_event(),
mutex_lock(), etc, resulting in the same issue.

> No, it's part of the solution. I haven't posted the full fuse freezing
> patch because I thought this could be profitably merged without the rest
> of the patch.

Please post the full patch, it'd be a lot better to see the big
picture instead of just a small part of it.

Thanks,
Miklos
