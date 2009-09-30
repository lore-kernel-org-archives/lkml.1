Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZI3NJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZI3NJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZI3NJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:09:23 -0400
Received: from cmpxchg.org ([85.214.51.133]:58617 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbZI3NJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:09:23 -0400
Date: Wed, 30 Sep 2009 15:08:15 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: swsusp on nommu, was 'Re: No more bits in vm_area_struct's vm_flags.'
Message-ID: <20090930130815.GA4134@cmpxchg.org>
References: <4AB9A0D6.1090004@crca.org.au> <Pine.LNX.4.64.0909232056020.3360@sister.anvils> <4ABC7FBC.4050409@crca.org.au> <20090930120202.GB1412@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930120202.GB1412@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 02:02:03PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > Does TuxOnIce rely on CONFIG_MMU?  If so, then the TuxOnIce patch
> > > could presumably reuse VM_MAPPED_COPY for now - but don't be
> > > surprised if that's one we clean away later on.
> > 
> > Hmm. I'm not sure. The requirements are the same as for swsusp and
> > uswsusp. Is there some tool to graph config dependencies?
> 
> I don't think swsusp was ported on any -nommu architecture, so config
> dependency on MMU should be ok. OTOH such port should be doable...

I am sitting on some dusty patches to split swapfile handling from
actual paging and implement swsusp on blackfin.  They are incomplete
and I only occasionally find the time to continue working on them.  If
somebody is interested or also working on it, please let me know.

	Hannes
