Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbZERJxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbZERJxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759026AbZERJsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:48:14 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58616 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759055AbZERJsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:48:13 -0400
Date: Mon, 18 May 2009 10:48:08 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by check_readable_bytes()
Message-ID: <20090518094808.GA12041@shareable.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com> <87k54iq2gv.fsf@basil.nowhere.org> <871vqqkdf0.wl%vmayatsk@redhat.com> <20090515093838.GB16682@one.firstfloor.org> <20090515134315.GB8235@shareable.org> <20090518093136.152a1bb7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518093136.152a1bb7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > System calls don't trigger SIGSEGVs so they can't rely on that when
> > calling read().  I'm not sure how they handle that.
> 
> Usually by touching the pages before the syscall.

Makes sense.

> (You can't rely on -EFAULT either in POSIX, its optional that it
> bothers to tell you and for example on MMUless it may well not)

On MMUless you wouldn't use page protection as a GC technique :-)
Is EFAULT really optional on systems with page protection?

-- Jamie
