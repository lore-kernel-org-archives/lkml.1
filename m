Return-Path: <linux-kernel-owner+w=401wt.eu-S1763847AbYARSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763847AbYARSGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763348AbYARSGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:06:36 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:3631 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762841AbYARSGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vs8zYrwd6EMkrIGJeOy1tTIDJ5L2ehq9h1COdhgEHGEExox+NLfs0M37xA9+pxYHvRkmQm2r2BKxmKZnAVOlgLPm7UnpNzIOJlwp4ibMRHDhWTnOz1Q5F8UU+0LEHo4XKJLxg3gp6pPcnrpx/kG+6IWw/DXyjJCYWwFmHBJAgBk=
Message-ID: <5eeb9ad90801181006r300e23e6t39159f1c1ccde0af@mail.gmail.com>
Date: Fri, 18 Jan 2008 19:06:28 +0100
From: DM <dm.n9107@gmail.com>
To: davids@webmaster.com
Subject: Re: Why is the kfree() argument const?
Cc: torvalds@linux-foundation.org, "Johannes Weiner" <hannes@saeurebad.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEKDJJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org>
	 <MDEHLPKNGKAHNMBLJOLKKEKDJJAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 6:02 AM, David Schwartz <davids@webmaster.com> wrote:
>
> However, *destroying* an object is not a metadata operation -- it destroys
> the data as well. This is kind of a philosophical point, but an object does
> not have a "does this object exist" piece of metadata. If an object does not
> exist, it has no data. So destroying an object destroys the data and is thus
> a write/modification operation on the data.
>

In C++ you can delete a const pointer. Now I know kernel hackers
aren't especially impressed with C++ but maybe someone could look up
the rationale for that design decision (I couldn't find it). It might
shed some light on this discussion.

/DM
