Return-Path: <linux-kernel-owner+w=401wt.eu-S1764182AbYBLS1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764182AbYBLS1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762129AbYBLS12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:27:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:33774 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761569AbYBLS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:27:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MqkAAt0DmbL5et5zSCG7ui+yAZKWl3SieZXv5DV+QFAFS4kz3h/f+hT7C2G5dH4gpoXfuma/Ozg0Zm/pu6QL6+kqDNmPynXGR4KCp/WYHFc9i7/SxsJynR5qh89h7ZSaJvypN+RHFGZKjGc+R2YX1bGwZQYVg9K8kS46OLLeM0E=
Date: Tue, 12 Feb 2008 19:26:43 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: udf regression: broken directory handling
Message-ID: <20080212182638.GA8334@joi>
References: <20080210104754.GH6737@joi> <20080211110910.GB9622@duck.suse.cz> <20080211191313.GA12375@joi> <20080212113916.GA13425@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212113916.GA13425@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:39:17PM +0100, Jan Kara wrote:
> On Mon 11-02-08 20:13:20, Marcin Slusarz wrote:
> > On Mon, Feb 11, 2008 at 12:09:10PM +0100, Jan Kara wrote:
> > >   Hi,
> > > 
> > > On Sun 10-02-08 11:48:17, Marcin Slusarz wrote:
> > > > Current mainline has a problem with reading file list.
> > > > Simple ls prints only 2 out of 8 files on my testing DVD.
> > > > Reverting your patch "udf: cleanup directory offset handling"
> > > > (af793295bf9ee92660f5e77d337b0493cea3f9b9) fixes the problem.
> > >   Thanks for testing! Do you have a way to create such UDF filesystem? For
> > > the filesystems I've created it seems to work just fine...
> > 
> > with patch applied:
>   <snip testing>
> 
>   Argh, I've submitted an old version of the patch missing changes in
> dir.c. Below is the missing hunk. Does UDF work for you with it?
Yes.

Marcin
