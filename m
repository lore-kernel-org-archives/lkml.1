Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751630AbYLQSde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbYLQSde (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYLQSdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:33:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:57141 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYLQSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:33:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HqXNP2ixXXcRIsoqmyMmiHb/DP25H8Gq+ifJAsMCyX1KVdKQsDBK7sjGujSlr25DwU
         BuoLXLpg0ie/RhWiRfp/ons6f1hSlmc+fhHO5EJ9v4cOJjNX2CijRzM6uroW4Zr9emmH
         CBCPg1zuOExWI080h9HrzJ9eP7GVxSdvk6S0A=
Date: Wed, 17 Dec 2008 21:33:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, linux-arch@vger.kernel.org,
        Alexander van Heukelum <heukelum@mailshack.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in assembly
	files
Message-ID: <20081217183318.GG8078@localhost>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1229505475-10219-2-git-send-email-heukelum@fastmail.fm> <20081217172640.GB5436@uranus.ravnborg.org> <20081217173824.GF8078@localhost> <20081217180023.GA5783@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217180023.GA5783@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Wed, Dec 17, 2008 at 07:00:23PM +0100]
...
| > Sam, I think eventually we should get something like this:
| > 
| > - KPROBE will be eliminated and explicit section descriptions
| >   are to be used
| > - ENTRY could be used / or renamed for something more descriptive
| >   and being used aligned jmp targets or in case of procs with
| >   shared body
| > - PROC/ENDPROC are to replace old ENTRY/END for procs being called
| >   mostly from C code
| 
| So what prevents us from extending ENTRY/END instead of introducing
| another set?
| Let us try to extend what we have and not introduce something new.
| 
| 	Sam
| 

It could disable us to make such a conversion step-by-step I think.
Of course it would be better to just extend ENTRY/END (since already
there) and we could even restrict it to X86 only at the beginning
but even then we have to check all ENTRY/END that they are used properly
(ie like a procedure markers having @function attribute). Not sure
what would be better. And btw ENDPROC is more descriptive then plain END :)

		- Cyrill -
