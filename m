Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZI1OA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZI1OA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZI1OA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:00:56 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53430 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZI1OAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:00:55 -0400
Date: Mon, 28 Sep 2009 09:59:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [bisected] Wireless regression in 2.6.32-git
Message-ID: <20090928135910.GA2698@tuxdriver.com>
References: <20090927151855.29efcc53@infradead.org> <Pine.LNX.4.64.0909271708210.8927@sister.anvils> <20090927204548.3ee3768f@infradead.org> <1254077199.6583.8.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254077199.6583.8.camel@johannes.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 08:46:39PM +0200, Johannes Berg wrote:
> On Sun, 2009-09-27 at 20:45 +0200, Arjan van de Ven wrote:
> 
> > > Subject: cfg80211: don't set privacy w/o key
> > > 
> > > When wpa_supplicant is used to connect to open networks,
> > > it causes the wdev->wext.keys to point to key memory, but
> > > that key memory is all empty. Only use privacy when there
> > > is a default key to be used.
> > 
> > 
> > indeed it does
> > 
> > can we get this into mainline soon ?
> 
> John's on his way home I suppose.

Yes, I'll get to it today -- sorry for the delays related to my travel!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
