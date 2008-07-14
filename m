Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYGNOYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYGNOYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYGNOY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:24:29 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47835 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753466AbYGNOY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:24:29 -0400
Message-ID: <487B619B.20608@sgi.com>
Date: Mon, 14 Jul 2008 07:24:27 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/15] x86_64: Fold pda into per cpu area
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <20080709165129.610711000@polaris-admin.engr.sgi.com> <m14p6ysol6.fsf@frodo.ebiederm.org> <20080713175408.GA17364@elte.hu>
In-Reply-To: <20080713175408.GA17364@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
...
>> Given that we have not yet understood the weird failure case.  This patch needs
>> to be split in two.  
>> - make the current per cpu variable section zero based.
>> - Move the pda into the per cpu variable section.
>>
>> There are too many variables at present the reported failure cases to
>> guess what is really going on.
>>
>> We can not optimize the per cpu variable accesses until the pda moves
>> but we can easily test for linker and tool chain bugs with zero
>> based pda segment itself.
> 
> agreed, a patch of this gravity and with a diffstat:
> 
>  12 files changed, 112 insertions(+), 142 deletions(-)
> 
> is indeed too large. Test failures that get bisected to this patch will 
> still cause people to guess about which aspect of the large patch caused 
> the problem.
> 
> 	Ingo

That split has been done and I've sent it to Jeremy and Peter for further
review.

Thanks,
Mike

