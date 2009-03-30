Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbZC3PXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbZC3PXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZC3PWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:22:45 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34580 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZC3PWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=wMFfJrBDl1mjlrRlwQIX2x75Cmm6BdU+Xv/C4lGeorihg005EPW9LxIbke6vcIlOMA
         iEJcqMQrAdCzBef81isbTRMC7Iohtb+LWRnoFd/vc5Jqy+w/cjk5iEBrUlQxo3g+6Hk5
         LN+gUQ3/nYYW/EOZ3gF0uubpWHiXud2C9HNTA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Fernando Luis =?iso-8859-1?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 5/7] vfs: Add  wbcflush sysfs knob to disable storage device writeback cache flushes
Date: Mon, 30 Mar 2009 17:14:08 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49D0B535.2010106@oss.ntt.co.jp> <49D0B978.5030107@oss.ntt.co.jp>
In-Reply-To: <49D0B978.5030107@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903301714.13174.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
> Add a sysfs knob to disable storage device writeback cache flushes.

The horde of casual desktop users (with me included) would probably prefer
having two settings -- one for filesystem barriers and one for fsync().

IOW I prefer higher performance at the cost of risking losing few last
seconds/minutes of work in case of crash / powerfailure but I would still
like to have the filesystem in the consistent state after such accident.

Thanks,
Bart
