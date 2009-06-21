Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZFUQr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZFUQr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 12:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZFUQrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 12:47:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbZFUQrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 12:47:19 -0400
Date: Sun, 21 Jun 2009 09:46:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: Andy Lutomirski <luto@mit.edu>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <4A3DABE1.50309@mit.edu> <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Jun 2009, Dave Airlie wrote:
> > 
> > I tried this tree (specifically, a merge of Linus' fb20871 this tree) on
> > Fedora 11 with modesetting enabled on an integrated Radeon 2100, and plymouthd
> > crashes immediately with a corrupt page table.  Photo attached.  After the
> > crash, bootup stops, although ctrl-alt-del works.
> 
> You need a different userspace, -ati from koji in F11 should do it.

Dave - no amount of userspace differences make a corrupted page table 
acceptable. 

This needs to be fixed. No excuses. Kernel crashes are never an issue of 
"you used the wrong user space".

		Linus
