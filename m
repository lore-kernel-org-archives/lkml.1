Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbYLaWa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbYLaWa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYLaWaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:30:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:40978 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYLaWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:30:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aLnMNRaSMf3ySQe7WVdbuYkx9bqYtw53q9bDVDJPeX8m6g2kr9X9h84HWt0mN6Xfzb
         THW+CyFHyQOdidBV/BE1aTITVPyCrWtk0nz4kviJAyTmZUdMjKQK4vEB+0MVodhJGBEO
         jWKETN1QMyTE9A7usk8QlzXOKfjfUF0rKl4YA=
Date: Thu, 1 Jan 2009 01:30:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: david@lang.hm, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20081231223007.GA3664@localhost>
References: <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <alpine.DEB.1.10.0812311204580.18334@asgard.lang.hm> <20081231191214.GF20882@localhost> <alpine.DEB.1.10.0812311316350.18569@asgard.lang.hm> <20081231202346.GH20882@localhost> <20081231202744.GA32152@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231202744.GA32152@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Wed, Dec 31, 2008 at 11:27:44PM +0300]
...
| | Thanks David, if I recognize correctly now it fails at
| | vfs_caches_init. hmm...
| | 
| | 		- Cyrill -
| 
| no suprises - vfs_caches_init uses SLAB_PANIC and since
| we seems to have "memory related" problems earlier now
| we've been catched explicitly by slab code.
| 
| 		- Cyrill -

on the other hand I think we would have different Oops
form here if it would really be slab panic... checking.

		- Cyrill -
