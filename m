Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934Ab0ABTWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab0ABTWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815Ab0ABTWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:22:54 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:41795 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0ABTWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WLVG0u732J6bHOgySnq13mY2W+WrSRUrJztclFxbbOPf5he6cRdOZnKd4+epqyjvLa
         ev1+6hzALZjv7EA6uHGOlXraLeRVEftlS2cng9ALYgGl4QVS8NEYbzg91FC2w0WVIa6r
         r956bp0mb3iO+2CjR2x3SG6ytNzxGmErcXvAs=
Date: Sat, 2 Jan 2010 20:22:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102192249.GD5076@nowhere>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <alpine.LFD.2.00.1001021118420.3630@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001021118420.3630@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 11:19:20AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 2 Jan 2010, Frederic Weisbecker wrote:
> > 
> > These changes fix a lot of lock inversions, some of them were
> > triggering soft lockups very easily in xattrs operations.
> 
> Should 2.6.32-stable merge this branch too?
> 
> 		Linus



No this only relies on the bkl removal patches merged in this cycle.

Thanks.

