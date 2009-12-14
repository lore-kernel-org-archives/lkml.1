Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZLNHIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZLNHIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZLNHIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:08:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36156 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbZLNHII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:08:08 -0500
Message-ID: <4B25E47C.1010803@gmail.com>
Date: Mon, 14 Dec 2009 08:08:44 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac
 v2
References: <cover.1260662994.git.re.emese@gmail.com> <20091214003836.GD7812@parisc-linux.org> <4B2595E7.701@gmail.com> <20091214021916.GB12196@linux-sh.org>
In-Reply-To: <20091214021916.GB12196@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Mon, Dec 14, 2009 at 02:33:27AM +0100, Emese Revfy wrote:
>> Matthew Wilcox wrote:
>>> On Mon, Dec 14, 2009 at 12:59:08AM +0100, re.emese@gmail.com wrote:
>>>> The following patch series attempts to constify several structures
>>>> that hold function pointers. This is only the initial batch, there
>>>> are about over 150 candidate structures, some of which can be
>>>> constified as well, I plan to submit them in the future.
>>> What a complete waste of time.  Until you respond to Al's:
>> I did: http://lkml.org/lkml/2009/12/5/140
>>
>> For even more discussion see: http://lkml.org/lkml/2009/12/6/111
>>
> Since you seem to have both the interest and abundance of spare time
> for working on this, have you considered just doing this in sparse? Al
> mentioned it here:
> 
> 	http://lkml.org/lkml/2009/12/8/511
> 
> which you don't seem to have replied to.

Please see my thoughts on sparse and related topics:
http://lkml.org/lkml/2009/12/10/283

> Until such a consensus is reached one way or the other, please refrain
> from sending hundreds of patches -- one or two are sufficient for showing
> what you want to do until folks are on board with it, as is the typical
> nature of mechanical changes.

I think there is consensus to constify ops variables as much as
possible (e.g., Alexey's similar patches).

The discussions in these threads were about constifying the ops structure
fields themselves and I already explained why they are useful, see the
above link and this one: http://lkml.org/lkml/2009/12/8/492
--
Emese
