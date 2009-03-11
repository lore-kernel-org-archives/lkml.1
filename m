Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZCKXRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZCKXRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 19:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZCKXRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 19:17:42 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:60219 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZCKXRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 19:17:42 -0400
To: =?iso-8859-1?Q?Fran=E7ois?= Cami <francois.cami@free.fr>
Cc: linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <theotso@us.ibm.com>,
       Martin Watson <mjwatsonuk@yahoo.co.uk>
Subject: Re: 2.6.28.7/ext2/e2fsprogs-1.41.3: apparently irreparable filesystem damage, filesystem not imageable
References: <87prgnpw1c.fsf@hades.wkstn.nix> <20090312001156.004e775e@free.fr>
From: Nix <nix@esperi.org.uk>
Emacs: it's not slow --- it's stately.
Date: Wed, 11 Mar 2009 23:17:28 +0000
In-Reply-To: <20090312001156.004e775e@free.fr> (=?iso-8859-1?Q?Fran=E7ois?=
 Cami's message of "Thu, 12 Mar 2009 00:11:56 +0100")
Message-ID: <87hc1zps3b.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-DCC--Metrics: hades 1356; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Mar 2009, François Cami told this:

> On Wed, 11 Mar 2009 21:52:15 +0000
> Nix <nix@esperi.org.uk> wrote:
>> What on earth is going on?
>
> AFAIK you are hitting the 16GB file size limit of a 1KB-block formatted
> ext{2,3} filesystem on /mnt/horizon/ .

Aha. I'd quite forgotten about that limit (normally I could go years
without writing files that large).

But 1Kb blocks? why the hell does it have 1Kb blocks, grumble grumble,
what idiot did that, this fs isn't a news spool (it was probably me in
the days before I realised what a performance hit non-page-sized blocks
incur).

... that's a bit annoying. Time to resize it down and make a new LV that
I can fit a copy of the errored fs onto (not that this will help until I
can make fsck work, but at least I can experiment with less worry).


So. No kernel bug, just a documented limit and extreme fsck
strangeness...
