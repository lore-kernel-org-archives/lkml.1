Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbYHEK6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbYHEK6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYHEK6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:58:25 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41651 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753772AbYHEK6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:58:24 -0400
Message-ID: <48983097.7040100@melbourne.sgi.com>
Date: Tue, 05 Aug 2008 20:51:03 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
Organization: File Serving Technologies ; Silicon Graphics Inc.
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: NeilBrown <neilb@suse.de>, Michael Shuey <shuey@purdue.edu>,
       Shehjar Tikoo <shehjart@cse.unsw.edu.au>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, rees@citi.umich.edu, aglo@citi.umich.edu
Subject: Re: high latency NFS
References: <20080730192110.GA17061@fieldses.org> <4890DFC7.3020309@cse.unsw.edu.au> <200807302235.50068.shuey@purdue.edu> <20080731031512.GA26203@fieldses.org> <18577.25513.494821.481623@notabene.brown> <20080801072320.GE6201@disturbed> <20080801191559.GI7764@fieldses.org> <20080804003206.GB6119@disturbed> <52873.192.168.1.70.1217813385.squirrel@neil.brown.name> <4896A4EE.9030706@melbourne.sgi.com> <20080804190715.GJ25940@fieldses.org>
In-Reply-To: <20080804190715.GJ25940@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Mon, Aug 04, 2008 at 04:42:54PM +1000, Greg Banks wrote:
>   
>> http://thread.gmane.org/gmane.linux.nfs/10372
>>
>>     
>
> Looks like that was me, apologies.  Breaking a documented interface to
> userspace just set off an alarm.  But if we really convince ourselves
> that it's useless, then OK.
>   
I think I explained last time how useless it is.
> (Though maybe your idea of leaving the line in place with just constant
> zeros is good.  Just because the data's useless doesn't mean someone out
> there may have a script that does otherwise useful things but that
> happens to fail if it can't parse /proc/net/rpc/nfsd.)
>   
Ok, I'm happy to do it that way.
> Looks like it's been two years now--any chance of rebasing those patches
> and resending?
>   
Yep.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.

