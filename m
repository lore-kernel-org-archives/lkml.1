Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZJ0SyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZJ0SyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZJ0SyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:54:06 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:50358 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZJ0SyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:54:05 -0400
Message-ID: <4AE741CE.6050200@s5r6.in-berlin.de>
Date: Tue, 27 Oct 2009 19:54:06 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
References: <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu> <57C9024A16AD2D4C97DC78E552063EA3E33D0A53@orsmsx505.amr.corp.intel.com> <20091026052118.GB13941@mit.edu> <4AE5E415.801@s5r6.in-berlin.de> <20091027180718.GC7915@mit.edu>
In-Reply-To: <20091027180718.GC7915@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2009 7:07 PM, Theodore Tso wrote:
> On Mon, Oct 26, 2009 at 07:01:57PM +0100, Stefan Richter wrote:
>> A missing
>> allocation failure check or a missing tracepoint don't break
>> bisectability.  So why discard this history?  (It was already published
>> in a release preview.)
> 
> There are multiple issues for rewinding patches.  One is to avoid
> breaking bisectability.  Other is to keep related changes in
> functionality in a single place.  2-3 years for now, does anyone
> really care about retaining development history?  In the human memory,
> one of the most important parts of long-term memory formation is
> *forgetting*; that is, editing down everything that happened down to
> the most cogent and importants bits of history.
[...]

Sure.  But when is the deadline for doing this?  The evening before you
send a pull request to Linus?  Or already when you commit to the branch
from which Stephen pulls into linux-next, which means:  This is code and
history which I would ask Linus to pull right now if he was in merge
mode today.

[I for one would indeed add non-essential credits or otherwise touch up
the history even if it already was in linux-next but Linus' next merge
window isn't there yet.  But I would batch such rewinds up for a single
occasion between merge windows, and only do them at all if there are
several such changes to make it worthwhile.  And I only do that because
I work at driver code with limited interaction with other subsystems,
and virtually no co-developers in the project.]
-- 
Stefan Richter
-=====-==--= =-=- ==-==
http://arcgraph.de/sr/
