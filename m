Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbYDNI10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbYDNI10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbYDNI1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:27:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51569 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbYDNI1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:27:14 -0400
To: aia21@cam.ac.uk
CC: akpm@linux-foundation.org, miklos@szeredi.hu, dwmw2@infradead.org,
       hch@infradead.org, me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <FEE6C6C4-7F19-4769-B674-FFFCA764EDD3@cam.ac.uk> (message from
	Anton Altaparmakov on Mon, 14 Apr 2008 09:11:35 +0100)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414004909.1b21b738.akpm@linux-foundation.org> <FEE6C6C4-7F19-4769-B674-FFFCA764EDD3@cam.ac.uk>
Message-Id: <E1JlK1N-00056I-JQ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Apr 2008 10:26:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> And I didn't advocate moving
> >> ntfs to fuse, still that was done and the resulting filesystem at the
> >> moment happens to outperform the kernel one in every respect ;)
> >
> > Gad.  Why?
> 
> Miklos has the wrong end of the stick.  No-one has "moved" ntfs to  
> fuse.  And the fuse implementation doesn't outperform the kernel  
> implementation in anything at all.  However the kernel one as  
> available in the kernel source tree doesn't have many write-features,  
> it can only overwrite files, it cannot create/delete files, etc.  So I  
> guess if you define "performance" to mean "features" then sure  
> ntfsmount/ntfs-3g have more features than the public kernel driver.   
> If you define "performance" to mean "speed" then no ntfsmount/ntfs-3g  
> can't compare to the kernel except in very limited and meaningless  
> benchmarks...

OK, I was exaggerating (notice the smiley).  But I do have a feeling
(and just a feeling, no hard data), that ntfs-3g is making the
in-kernel ntfs filesystem increasingly irrelevant.  And yes, that's
mostly because of the features, but also because the performance is
not at all as bad, as some people would think a userspace filesystem
has to be.

Miklos
