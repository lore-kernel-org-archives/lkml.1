Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbXJKWDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbXJKWDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbXJKWC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:02:57 -0400
Received: from main.gmane.org ([80.91.229.2]:59886 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbXJKWC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:02:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: User-space tuner misconception: it doesn't have anything to do with
 binary blobs
Date: Thu, 11 Oct 2007 19:02:14 -0300
Organization: http://u-br.net
Message-ID: <64j2u4-3tk.ln1@tux.abusar.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 200-207-206-233.dsl.telesp.net.br
X-Newsreader: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
X-Face: "g*5eYHIY,3>,mjb*Ct*Nas)P6a$h'JGcnp371H.F=?]}zS6?v8,<jRw3BK3FHOG?nLkDqh9X-:Ib$K8^Te^}L]1&;"<9qSe0G4^Lx?2JjSc1-i|.l$BI;vG\O!vkgrC_`LS0j@f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	I read today on kerneltrap the following:

http://kerneltrap.org/Linux/Avoiding_Blobs

	and I notice that people have a misconception about how the
user space tuner proposed by Markus Rechberger works.

	I've been using Markus' code for a long time and he's the only
one that made my device works (a Powercolor Real Angel 330 capture
board = cx88 chipset with Xceive firmware dependent tuner).

	In the beginning, I used Markus' xc3028-tuner kernel module,
but it was always a fight between V4L developers and I, as a user, have
to wait many months... Ok, I tried to help Markus as most as I can and
I'd like to clarify what's really the user space tuner proposal:

1) the only difference between using a xc3028-tuner kernel module and a
user space tuner is obvious: we use a daemon that do the job that the
module made before.

2) there isn't any binary blobs. It doesn't matter if we use the kernel
module or the user space tuner, I *have* to use the provided firmware,
which is a separate thing.

	To sum up: if it was not Markus, I never could use my device.
So I hope Linus reconsiders his position, because otherwise who knows
when I can use my device? As far as i know, Markus is the only
programmer working on this.

	It doesn't make sense to reject a code that surely works very
well and leave users waiting forever... because companies won't help...

	And it must be made clear: all Markus' code is completely open
source, GPL etc:

http://mcentral.de/wiki/index.php/Userspace_tuner

	The V4l project is very slow. When i bought my device maybe a
year ago, I read about the cx88 support... and it's the same way... it
didn't evolve at all... it seems that nobody cares... so when someone
really does the job, why it's rejected? It's non sense. Linux supports
few devices and I don't think valuable code should be rejected this way.

-- 
Linux 2.6.23: Arr Matey! A Hairy Bilge Rat!
http://www.lastfm.pt/user/danielfraga
http://u-br.net

