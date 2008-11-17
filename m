Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYKQTai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYKQTai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYKQT3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:29:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:5000 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbYKQT3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:29:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lsgVjiayLZ0mXiAbuTQS53AZM/0B0YFAdisnKHgr1namSYqDKka1sshxkz/oLR2VTD
         kstiZaIXAPbQtaetO/4EmNZsWf7NAw95b0sGUehaynEYnPRNVAElc7XPmB5BvrMf/jWN
         SEVTMB/n2l+rnhCLUGYtyFzzImqSrNk154s6E=
Date: Mon, 17 Nov 2008 22:29:41 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@lusi.uni-sb.de>,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [RFC] x86: save_args out of line
Message-ID: <20081117192941.GB9944@localhost>
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm> <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117125317.GK6703@one.firstfloor.org> <1226936257.32609.1285214311@webmail.messagingengine.com> <20081117182340.GN6703@one.firstfloor.org> <20081117192216.GA9944@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117192216.GA9944@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Nov 17, 2008 at 10:22:16PM +0300]
| [Andi Kleen - Mon, Nov 17, 2008 at 07:23:40PM +0100]
| ...
| | 
| | Ok. Hopefully it's worth the effort. The branch misprediction bubble
| | should not be too bad, perhaps it'll make up for the other cycles
| | you're adding. But even if it doesn't decreasing cache line foot print is 
| | always a good thing.
| ...
| 
| May I turn in? :)
|

I meant - turn into thread not "turn in" (ouch).
 
		- Cyrill -
