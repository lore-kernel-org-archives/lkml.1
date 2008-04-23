Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYDWNgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYDWNgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYDWNgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:36:09 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:1877 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbYDWNgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:36:08 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] scheduler changes for v2.6.26
Date: Wed, 23 Apr 2008 15:36:02 +0200
User-Agent: KMail/1.9.9
References: <20080419181304.GB21353@elte.hu> <200804231136.50639.elendil@planet.nl> <20080423094644.GB23293@elte.hu>
In-Reply-To: <20080423094644.GB23293@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Richard Jonsson <richie@coderworld.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231536.03076.elendil@planet.nl>
X-OriginalArrivalTime: 23 Apr 2008 13:36:05.0472 (UTC) FILETIME=[FAD69600:01C8A546]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008, you wrote:
> > BTW, did either of you actually look at the traces I sent for .24? I
> > never got any feedback on those.
>
> hm, i looked at them - i thought i mailed you about that but indeed i
> didnt (sorry about that) - the traces were too short in scope - they
> just covered a few dozen milliseconds in scope, while your description
> said that the problem occured seconds into the trace.
>
> > P.S. I've got group scheduling active in this config as my tests with
> > .24 showed that did not make any difference. Can rerun without if
> > needed.

Ah, I was wondering about that. Sorry about the mistake, but if you'd let me 
know I could have run new traces.

If there's anything wrong with the current traces, please _do_ let me know. 
Problem is that I just see a huge pile of data without really knowing what 
I'm looking at. For example, I've no idea what the time units are. If I've 
guessed those wrong, it's not surprising that you don't see anything as I'm 
then basically stopping the trace too late or including too few entries.

What would be a good value for trace_entries to get a decent time interval?

If there's more documentation available about what's in those files, please 
let me know.

Cheers,
FJP

P.S. It would probably be good to just mention the units in the headers of 
the debug files. It may be obvious to you, but that way it's obvious even 
to morons like me :-P
