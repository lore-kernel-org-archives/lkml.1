Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYCCDHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYCCDHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 22:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbYCCDGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 22:06:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:56174 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbYCCDGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 22:06:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nqug/HZ47P6B706tFtM2vt3hxt14v4QiKj94bpf/qZrKhhgWCdwDTOB/sC6Jcuul1ldLxe69Ij4OpNRxndBv1n3zjtXBokhfTOwJTMsnWHyyG+5aeL25ZRnDZS3ZlxZ1JxXutZDKTZmMPxVm9mA6x5Pvf3XiyUAyWtjRGRvvEvs=
Message-ID: <44c63dc40803021906j6102b0aq6982f46cba52f476@mail.gmail.com>
Date: Mon, 3 Mar 2008 12:06:54 +0900
From: "minchan Kim" <barrioskmc@gmail.com>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 12/21] No Reclaim LRU Infrastructure
Cc: "Rik van Riel" <riel@redhat.com>, linux-kernel@vger.kernel.org,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <44c63dc40803021904n5de681datba400e08079c152d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080228192908.126720629@redhat.com>
	 <20080228192929.031646681@redhat.com>
	 <44c63dc40802282058h67f7597bvb614575f06c62e2c@mail.gmail.com>
	 <1204296534.5311.8.camel@localhost>
	 <44c63dc40803021904n5de681datba400e08079c152d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I sended HTML format, so fail to send linux-kernel@vger.kernel.org
I will resend in TEXT/PLAIN format.

On Mon, Mar 3, 2008 at 12:04 PM, minchan Kim <barrioskmc@gmail.com> wrote:
> One more thing.
>
> zoneinfo_show_print fail to show right information.
> That's why 'enum zone_stat_item' and 'vmstat_text' index didn't matched.
> This is a problem about CONFIG_NORECLAIM, too.
>
>
>
>
>
> On Fri, Feb 29, 2008 at 11:48 PM, Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
>
> >
> >
> >
> > On Fri, 2008-02-29 at 13:58 +0900, minchan Kim wrote:
> > >
> > >         +#ifdef CONFIG_NORECLAIM
> > >         +static inline void lru_cache_add_noreclaim(struct page *page)
> > >         +{
> > >         +       __lru_cache_add(page, LRU_NORECLAIM);
> > >         +}
> > >         +#else
> > >         +static inline void lru_cache_add_noreclaim(struct page *page)
> > >         +{
> > >         +       BUG("Noreclaim not configured, but page added
> > >         anyway?!");
> > >         +}
> > >         +#endif
> > >         +
> > >
> > > BUG() can't take a argument.
> >
> > Right.  I don't have a clue how that got there :-(.
> >
> > Thanks,
> > Lee
> >
> >
>
>
>
> --
> Thanks,
> barrios



-- 
Thanks,
barrios
