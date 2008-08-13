Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYHMKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYHMKkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYHMKkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:40:42 -0400
Received: from 8bytes.org ([88.198.83.132]:40921 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbYHMKkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:40:41 -0400
Date: Wed, 13 Aug 2008 12:40:38 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Setup code crashes my old 486 box
Message-ID: <20080813104038.GE4342@8bytes.org>
References: <20080812224703.GV31439@8bytes.org> <48A2155B.1020904@zytor.com> <20080813080705.GW31439@8bytes.org> <20080813100013.GD2214@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813100013.GD2214@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 12:00:13PM +0200, Ingo Molnar wrote:
> 
> * Joerg Roedel <joro@8bytes.org> wrote:
> 
> > On Tue, Aug 12, 2008 at 03:57:31PM -0700, H. Peter Anvin wrote:
> > > Right in concept, but I dislike the implementation (duplication of the 
> > > CPU detect code we already have).  Could you try this patch and see if 
> > > it works for you?
> > 
> > Cool, with a small modification to fix a build error with it the
> > resulting kernel boots my machine. Thanks.
> > Would be cool to have this patch one merged soon :-)
> > Attached is your patch with my little build fix. It redefines a values
> > already defines in cpufeatures.h but I can't include that file in the
> > boot code so I simply redeclared it. Maybe there is a cleaner solution
> > for this.
> 
> thanks, i've commited the fix below to tip/x86/urgent - it should show 
> up in v2.6.27-rc4 and it might even be backportable to -stable. I've 
> added your Signed-off-by - is that ok with you?

Ok, cool. Thats fine for me. Thanks.

Joerg

