Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076Ab0A1Icg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab0A1Icg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 03:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422Ab0A1Icf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 03:32:35 -0500
Received: from abydos.nerdbox.net ([216.151.149.55]:51304 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0A1Icf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 03:32:35 -0500
Date: Thu, 28 Jan 2010 00:32:32 -0800 (PST)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chris Frost <frost@cs.ucla.edu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Benny Halevy <bhalevy@panasas.com>, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: add fincore(2) (mincore(2) for file descriptors)
In-Reply-To: <20100128002313.2b94344e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.00.1001280028160.2909@abydos.NerdBox.Net>
References: <20100120215712.GO27212@frostnet.net> <20100126141229.e1a81b29.akpm@linux-foundation.org> <alpine.DEB.1.00.1001272319530.2909@abydos.NerdBox.Net> <20100128002313.2b94344e.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010, Andrew Morton wrote:

> On Wed, 27 Jan 2010 23:42:35 -0800 (PST) Steve VanDeBogart <vandebo-lkml@NerdBox.Net> wrote:
>
>>> Is it likely that these changes to SQLite and Gimp would be merged into
>>> the upstream applications?
>>
>> Changes to the GIMP fit nicely into the code structure, so it's feasible
>> to push this kind of optimization upstream.  The changes in SQLite are
>> a bit more focused on the benchmark, but a more general approach is not
>> conceptually difficult.  SQLite may not want the added complexity, but
>> other database may be interested in the performance improvement.
>>
>> Of course, these kernel changes are needed before any application can
>> optimize its IO as we did with libprefetch.
>
> That didn't really answer my question.
>
> If there's someone signed up and motivated to do the hard work of
> getting these changes integrated into the upstream applications then
> that makes us more interested.  If, however it was some weekend
> proof-of-concept hack which shortly dies an instadeath then...  meh,
> not so much.

Sorry I misunderstood.  The maintainer of GraphicsMagick has already
contacted us about making changes similar to our GIMP changes.  So yes,
there is interest in really using these changes.

--
Steve
