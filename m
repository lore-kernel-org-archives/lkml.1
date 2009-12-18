Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZLRDJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZLRDJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 22:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZLRDJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 22:09:21 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39160 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZLRDJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 22:09:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MxMTrrTKoypA+UFAPo0xGkS82eLfUmVJ0EQ5JeHDphTHKHgfpt7eEOPl5BtaEERcI2
         gHjQcOgseOV9m3AUydz4h38PRo8r61hAmG3GeuxXfmIyzaj+m7EBKQqwlypEnhI3aYox
         Y9MJReXRKM22uEvbKrbzl40o9bYc4mc/TKQFY=
Date: Fri, 18 Dec 2009 04:09:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091218030915.GC16470@nowhere>
References: <20091218005650.GA20667@redhat.com> <20091218014021.CB474135F@magilla.sf.frob.com> <20091218021042.GA508@redhat.com> <20091218025806.GA16470@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218025806.GA16470@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 03:58:09AM +0100, Frederic Weisbecker wrote:
> Yep, that doesn't fix your problem but this patch makes sense
> in that if we were not in user mode while the step occured,
> we shouldn't send the signal.


That wouldn't happen actually, as we clear the STEP flag before. 

