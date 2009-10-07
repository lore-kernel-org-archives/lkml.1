Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZJGC0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZJGC0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZJGC0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:26:07 -0400
Received: from ppp59-167-189-244.static.internode.on.net ([59.167.189.244]:55819
	"EHLO isinu.rimspace.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZJGC0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:26:07 -0400
X-Greylist: delayed 674 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 22:26:06 EDT
From: Daniel Pittman <daniel@rimspace.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed s2disk/ram cycle
References: <1254863215.11577.23.camel@maxim-laptop>
	<200910062358.32417.rjw@sisk.pl>
	<20091006225329.GA27646@khazad-dum.debian.net>
	<200910070102.47293.rjw@sisk.pl>
	<20091007012930.GA7022@khazad-dum.debian.net>
Date: Wed, 07 Oct 2009 13:14:10 +1100
In-Reply-To: <20091007012930.GA7022@khazad-dum.debian.net> (Henrique de Moraes
	Holschuh's message of "Tue, 6 Oct 2009 22:29:30 -0300")
Message-ID: <87vdisq7bh.fsf@rimspace.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh <hmh@hmh.eng.br> writes:
> On Wed, 07 Oct 2009, Rafael J. Wysocki wrote:
>> On Wednesday 07 October 2009, Henrique de Moraes Holschuh wrote:
>> > On Tue, 06 Oct 2009, Rafael J. Wysocki wrote:
>> > > > You do sync file-systems before entering the hibernation, don't you?
>> > > 
>> > > Yes, a sync is there, but it is not effective on some filesystems.
>> > 
>> > Which ones?
>> 
>> XFS for one example.
>
> Interesting.  So XFS is not only a Bad Idea for /, but also for anything
> that might enter S3/S4.  Not nice.  I sure hope it doesn't do a
> half-assed job of flushing and checkpointing itself during machine
> shutdown/restart like it apparently does when told to "sync" before
> S3/S4...

For what it is worth, I would also be quite interested to know /why/ XFS is
bad in this regard.  Is it just the previously stated "XFS writes to disk
despite freezing kernel threads" issue, or something deeper?

        Daniel
-- 
✣ Daniel Pittman            ✉ daniel@rimspace.net            ☎ +61 401 155 707
               ♽ made with 100 percent post-consumer electrons
