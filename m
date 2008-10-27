Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYJ0UKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYJ0UKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYJ0UJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:09:55 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53950 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYJ0UJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:09:54 -0400
Date: Mon, 27 Oct 2008 16:07:36 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       linux-kernel@vger.kernel.org,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: unify appropriate bits from dumpstack_32 and
	dumpstack_64
Message-ID: <20081027200736.GA3220@hmsreliant.think-freely.org>
References: <20081023144006.GA14149@hmsendeavour.rdu.redhat.com> <1225128425.8714.1281501519@webmail.messagingengine.com> <20081027182148.GL3046@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027182148.GL3046@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 07:21:48PM +0100, Ingo Molnar wrote:
> 
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> > On Thu, 23 Oct 2008 10:40:06 -0400, "Neil Horman"
> > <nhorman@tuxdriver.com> said:
> > > Hey all-
> > > 	As promised, now that dumpstack_32 and dumpstack_64 have so many bits in
> > > common, we should merge the in-sync bits into a common file, to prevent them
> > > from diverging again.  This patch removes bits which are common between
> > > dumpstack_32.c and dumpstack_64.c and places them in a common dumpstack.c
> > > which is built for both 32 and 64 bit arches.  
> > > 
> > > Regards
> > > Neil
> > > 
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > A bit late, maybe, but if it matters:
> > 
> > Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> i've updated the commit, thanks.
> 
> 	Ingo
> 

Thanks guys!
Neil

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
