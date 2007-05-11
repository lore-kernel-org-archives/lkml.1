Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbXEKBIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbXEKBIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762399AbXEKBI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:08:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38198 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762395AbXEKBIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:08:25 -0400
Date: Fri, 11 May 2007 10:08:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: y-goto@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, clameter@sgi.com, mel@csn.ul.ie
Subject: Re: [RFC] memory hotremove patch take 2 [01/10] (counter of
 removable page)
Message-Id: <20070511100851.f7d18ae8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <p73bqgsg5ef.fsf@bingen.suse.de>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
	<20070509120132.B906.Y-GOTO@jp.fujitsu.com>
	<p73bqgsg5ef.fsf@bingen.suse.de>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 May 2007 15:44:08 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Yasunori Goto <y-goto@jp.fujitsu.com> writes:
> 
> 
> (not a full review, just something I noticed)
> > @@ -352,6 +352,8 @@ struct sysinfo {
> >  	unsigned short pad;		/* explicit padding for m68k */
> >  	unsigned long totalhigh;	/* Total high memory size */
> >  	unsigned long freehigh;		/* Available high memory size */
> > +	unsigned long movable;		/* pages used only for data */
> > +	unsigned long free_movable;	/* Avaiable pages in movable */
> 
> You can't just change that structure, it is exported to user space.
> 
Okay. We'll drop this.

Thanks,
-Kame

