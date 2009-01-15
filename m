Return-Path: <linux-kernel-owner+w=401wt.eu-S934365AbZAOVDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934365AbZAOVDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbZAOUfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:35:00 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42324 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933627AbZAOUe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:34:58 -0500
Message-ID: <496F9DEF.5060400@sgi.com>
Date: Thu, 15 Jan 2009 12:34:55 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: crash: IP: [<ffffffff80478092>] __bitmap_intersects+0x48/0x73
 [PATCH supplied]
References: <496BF6D5.9030403@sgi.com> <20090113130048.GB31147@elte.hu>	<496CAF5A.3010304@sgi.com> <496D0F46.2010907@sgi.com>	<496D2172.6030608@sgi.com> <20090114165431.GA18826@elte.hu>	<20090114165524.GA21742@elte.hu> <20090114175126.GA21078@elte.hu>	<496E78BA.5040609@sgi.com> <20090115101428.GG5833@elte.hu>	<496F67D8.4060507@sgi.com> <jepriolaat.fsf@sykes.suse.de>
In-Reply-To: <jepriolaat.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>>  23> git-remote update
>> Updating linus
>> Updating tip
> 
> This only updates the remotes, but does not merge anything into your
> local branch.  You need to run "git merge tip" to do that.
> 
> Andreas.
> 

Ahh, that's the secret ingredient!

In my particular instance it's:

	git merge tip/cpus4096

(Git has been quite a learning experience... ;-)

Thanks!
Mike
 
