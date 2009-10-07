Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZJGBai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZJGBai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbZJGBai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:30:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40881 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbZJGBah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:30:37 -0400
X-Sasl-enc: JgWqOsYUABSE2440iOKek9lHzM6l3DqkFbi+dNhb3RQz 1254878973
Date: Tue, 6 Oct 2009 22:29:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed
 s2disk/ram cycle
Message-ID: <20091007012930.GA7022@khazad-dum.debian.net>
References: <1254863215.11577.23.camel@maxim-laptop>
 <200910062358.32417.rjw@sisk.pl>
 <20091006225329.GA27646@khazad-dum.debian.net>
 <200910070102.47293.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910070102.47293.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Oct 2009, Rafael J. Wysocki wrote:
> On Wednesday 07 October 2009, Henrique de Moraes Holschuh wrote:
> > On Tue, 06 Oct 2009, Rafael J. Wysocki wrote:
> > > > You do sync file-systems before entering the hibernation, don't you?
> > > 
> > > Yes, a sync is there, but it is not effective on some filesystems.
> > 
> > Which ones?
> 
> XFS for one example.

Interesting.  So XFS is not only a Bad Idea for /, but also for anything
that might enter S3/S4.  Not nice.  I sure hope it doesn't do a
half-assed job of flushing and checkpointing itself during machine
shutdown/restart like it apparently does when told to "sync" before
S3/S4...

Would you be so kind to disclose to us, the uninitated, which other
filesystems are unsafe when faced with a sleep/suspend request?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
