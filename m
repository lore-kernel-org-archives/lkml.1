Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZI3SsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZI3SsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 14:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZI3SsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 14:48:14 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49594 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZI3SsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 14:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RNKDz3yQFdITo/PeOoZcX23wOkE+/ybDN2pBf8XfpCgh4/oeCdIlyVTDQvtDtnJmmf
         h0vpxDnl68cTAXr006BP3tZ9JIUkYoEj1RhspMWX/K9g1+DzguF5pUxsvCpbnE3OLF1d
         jts7rTwnzQ/wTrDCHN3/wYO9Vn1VUUuZTVvws=
Date: Wed, 30 Sep 2009 20:48:12 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, david.graham@intel.com,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Message-ID: <20090930184812.GA2484@bizet.domek.prywatny>
References: <20090915120538.GA26806@bizet.domek.prywatny> <200909170118.53965.rjw@sisk.pl> <4AB29F4A.3030102@intel.com> <200909180027.37387.rjw@sisk.pl> <20090922233531.GA3198@bizet.domek.prywatny> <20090929135810.GB14911@csn.ul.ie> <20090930153730.GA2120@bizet.domek.prywatny> <20090930155543.GC17906@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930155543.GC17906@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 04:55:43PM +0100, Mel Gorman wrote:
> On Wed, Sep 30, 2009 at 05:37:30PM +0200, Karol Lewandowski wrote:
> > I've started with bc75d33f0 (one commit before d239171e4 in Linus'
> > tree) but then my system fails to resume.
> > 
> 
> Does the bug require a suspend/resume or would something like
> 
> rmmod e100
> updatedb
> modprobe e100
> 
> reproduce the problem?

Yes, it does reproduce the problem.  Thanks a lot for that.

I'll try to bisect it as my free time permits (which may take a while,
unfortunately).

Thanks.
