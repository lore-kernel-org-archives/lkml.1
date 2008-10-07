Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYJGLo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYJGLo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYJGLor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:44:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38031 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbYJGLoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:44:46 -0400
Date: Tue, 7 Oct 2008 13:50:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007115052.GI20740@one.firstfloor.org>
References: <20081007195837.5A6B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081007112119.GG20740@one.firstfloor.org> <20081007202127.5A74.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081007113050.GD5126@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007113050.GD5126@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:30:51PM +0300, Kirill A. Shutemov wrote:
> On Tue, Oct 07, 2008 at 08:26:03PM +0900, KOSAKI Motohiro wrote:
> > > > Honestly, I don't like that qemu specific feature insert into shmem core.
> > > 
> > > I wouldn't say it's a qemu specific interface.  While qemu would 
> > > be the first user I would expect more in the future. It's a pretty
> > > obvious extension. In fact it nearly should be default, if the
> > > risk of breaking old applications wasn't too high.
> > 
> > hm, ok, i understand your intension.
> > however, I think following code isn't self describing.
> > 
> > 	addr = shmat(shmid, addr, SHM_MAP_HINT);
> > 
> > because HINT is too generic word.
> > I think we should find better word.
> > 
> > SHM_MAP_NO_FIXED ?
> 
> I like it.
> Andi?

SHM_MAP_NOT_FIXED perhaps.

I personally would call it SHM_MAP_SEARCH_HINT

But to be honest I have no strong opinion on the naming. Perhaps others have.

-Andi
-- 
ak@linux.intel.com
