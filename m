Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZBWITt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZBWITt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZBWITf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:19:35 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:3811 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZBWITe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aBvquPRYSS8d0vK9qP5+0ZmkHL8Mi/dEOBXf2Io4VAGx8Mnliu6meLK7BJPXo+331Z
         3gCvTsEX4ayWq6DHDDQFYi8tWyWr0hD/LWR69WKE0ncMz04ZVVggrpcMvI/p89FKtkJE
         u9qoLxDGRtfsP4nSHocsAvDVqEcXIK79K4TTA=
Date: Mon, 23 Feb 2009 11:19:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paul Menage <menage@google.com>, Jesper Juhl <jj@chaosbits.net>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, Simon Derr <simon.derr@bull.net>
Subject: Re: [PATCH] Remove some pointless conditionals before kfree() in
	kernel/cgroup.c
Message-ID: <20090223081942.GD29898@localhost>
References: <alpine.LNX.2.00.0902222254350.1236@swampdragon.chaosbits.net> <6599ad830902230012x170e2183q1540670d761ef80e@mail.gmail.com> <20090223081757.GC29898@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223081757.GC29898@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Feb 23, 2009 at 11:17:57AM +0300]
...
| | Thanks. I'm a bit surprised that it also shrunk the data segment size
| | (and in fact, by more than the text segment size). Any idea how that
| | came about?
| 
| Maybe kfree was inlined by gcc for some reason?

What I'm talking about? :)
Sorry for noise.

	- Cyrill -
