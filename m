Return-Path: <linux-kernel-owner+w=401wt.eu-S1764145AbYCGVEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764145AbYCGVEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932144AbYCGVEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:04:10 -0500
Received: from kai.krose.org ([140.186.190.96]:55286 "EHLO mail.krose.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760149AbYCGVEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:04:09 -0500
Message-ID: <47D1ADC5.1050108@krose.org>
Date: Fri, 07 Mar 2008 16:04:05 -0500
From: Kyle Rose <krose@krose.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
Subject: Re: READDIRPLUS max mount option
References: <47D1995E.6060501@krose.org>	 <1204919978.16746.12.camel@heimdal.trondhjem.org>	 <47D1A0F5.2070501@krose.org> <1204922570.16746.37.camel@heimdal.trondhjem.org>
In-Reply-To: <1204922570.16746.37.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The size of the actual READDIRPLUS requests is completely unaffected by
> your patch. Your change actually means that the client will continue to
> use READDIRPLUS on very large directories instead of falling back to
> readdir.
>   
Sorry to be imprecise.  "Size of request" should be "size of response" 
or "cost of request".  The meaning is clear, I think.
> If you want a faster readdir(), you will find that splitting those huge
> directories up into smaller subdirs is an alternative solution that
> tends to scale much better on both client and server.
>   
Agreed that this is probably the least terrible of the available 
solutions, but in my specific case it requires a more extensive 
modification to my software than the relatively minor kernel change.
> Having hundreds of mount options for minor tweaks is not an acceptable
> practice. Each mount option needs to be abundantly justified.
>   
Regarding your straw man, nobody's proposing hundreds of mount options.  
I imagine the effort required to implement each one would keep such a 
thing from happening. ;-)
> Since we're talking about what is really a quite arbitrary limit, I can
> certainly see an argument for why we might want a way to change it, but
> I'm still not convinced that we need to be setting this parameter at the
> mountpoint level.
Fair enough.  A proc entry to alter this globally would be an acceptable 
compromise for me, even if my local sysadmins might not like it.

Kyle
