Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544Ab0A0XIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0A0XIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420Ab0A0XIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:08:47 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36613 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab0A0XIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:08:46 -0500
From: nhorman@mail.tuxdriver.com
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Neil Horman" <nhorman@tuxdriver.com>
Cc: "Oleg Nesterov" <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       abelay@mit.edu, benh@kernel.crashing.org, drbd-dev@lists.linbit.com,
       gregkh@suse.de, jmoskovc@redhat.com, menage@google.com,
       mfasheh@suse.com, mingo@redhat.com, neilb@suse.de,
       shemminger@linux-foundation.org, spock@gentoo.org,
       t.sailer@alumni.ethz.ch, takedakn@nttdata.co.jp,
       viro@zeniv.linux.org.uk
Date: Wed, 27 Jan 2010 18:08:42 -0500
User-Agent: LogicMail/1.0.4
Subject: Re: + exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather -than-0.patch added to -mm tree
In-Reply-To: <20100127133408.9d8f72fe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
    charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NaGzz-0002tJ-OY@smtp.tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 Jan 2010 16:34:08 -0500, Andrew Morton wrote:
> On Wed, 27 Jan 2010 16:22:39 -0500
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > On Wed, Jan 27, 2010 at 06:58:52PM +0100, Oleg Nesterov wrote:
> > > On 01/27, Oleg Nesterov wrote:
> > > >
> > > > Currently only d_coredump() needs this new feature, but please note
> > > > that ____call_usermodehelper() was already "uglified" for the coredumping
> > > > over the pipe.
> > > >> > > > If we add sub_info->finit(), then probably we should move the code
> > > > under "if (sub_info->stdin)" from ____call_usermodehelper() to
> > > > core_pipe_setup() ?
> > > 
> > > And, perhaps, we should not change call_usermodehelper() and all its
> > > callers? If the caller needs ->finit() it can customize subprocess_info
> > > like call_usermodehelper_pipe() already does?
> > > 
> > > To clarify, I don't have a "strong" opinion, I am just asking.
> > > 
> > I'm not opposed to that, Since Andew has already taken these patches, I'll
> > tinkier to see how such an implementation change looks, and post some follow on
> > patches if it seems good.  I'll clean up the comments while I'm at it.
> > 
> 
> The patch conflicts a bit with Andi's
> sysctl-add-call_usermodehelper_cleanup.patch so I dropped v1 of
> exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0.patch
> 
That's fine.  I'll repost with the cleanups you & oleg noted in a few days

Regards
Neil

