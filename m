Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYCMNoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYCMNoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYCMNoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:44:22 -0400
Received: from zux006-051-205.adsl.green.ch ([81.6.51.205]:20935 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751952AbYCMNoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:44:22 -0400
Date: Thu, 13 Mar 2008 13:22:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080313132211.6af855b3@the-village.bc.nu>
In-Reply-To: <200803122314.18244.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803121029.54108.phillips@phunq.net>
	<47D8BE08.6040800@davidnewall.com>
	<200803122314.18244.phillips@phunq.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 22:14:16 -0800
Daniel Phillips <phillips@phunq.net> wrote:

> On Wednesday 12 March 2008 22:39, David Newall wrote:
> > Daniel Phillips wrote:
> > > Particularly about Ext2/Ext3, which does recover well from random damage.
> > > My experience.
> > 
> > By "recover well", you must mean "loses massive swabs of data, leaving
> > the system unbootable and with enormous numbers of user files missing." 
> > My experience.
> > 
> > Expecting fsck to cover for missed writes is stupid.
> 
> Whatever it can get off the disk it gets.  It does a good job.  If you
> don't think so, then don't tell me, tell Ted.

He knows. Ext3 cannot recover well from massive loss of intermediate
writes. It isn't a normal failure mode and there isn't sufficient fs
metadata robustness for this. A log structured backing store would deal
with that but all you apparently want to do is scream FUD at anyone who
doesn't agree with you.

Alan
