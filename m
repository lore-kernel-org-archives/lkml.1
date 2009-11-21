Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZKUTFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZKUTFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 14:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbZKUTF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 14:05:28 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:32978 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbZKUTFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 14:05:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=U5DnR6b6ASOYK6dYmLAWOd7equHcpu0pDBSnVG39TGVi6AjBjUh8+GHMOwz+E5Uu+w
         WJaMEC8GGq+VwAO2RrXj9fYYNrNrVjirpGOKdedPWxKdCOacdaM+jrACTufZYpILDNSG
         LgH19v8779ItoaM26eFFKbZ+0wLdS5LSjDwUo=
Date: Sat, 21 Nov 2009 20:04:42 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Message-Id: <20091121200442.61740f37.kristoffer.ericson@gmail.com>
In-Reply-To: <4B08258E.9050607@gmail.com>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
	<mYW9sxtWd2G.A.EnF.gDACLB@chimera>
	<4B08258E.9050607@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009 09:38:22 -0800
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
> > Subject		: Disassociating atheros wlan
> > Submitter	: Kristoffer Ericson<kristoffer.ericson@gmail.com>
> > Date		: 2009-09-24 10:16 (59 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4
> >
> >
> >
> >    
> I did a bisect yesterday on this, and the results
> seemed to have worked over here by reverting:
> 
> 75e6c3b72b3ab01c47629f3fbd0fed4e6550bf3a
> cfg80211: lower dynamic PS timeout to 100ms
> 
> if Kristoffer can try reverting this one
> to see, then we can go from there.

In the process of doing that as we speak.

> 
> Justin P. Mattock
> 
> 
> 


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
