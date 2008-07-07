Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYGGV62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYGGV62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbYGGV5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:57:51 -0400
Received: from eazy.amigager.de ([213.239.192.238]:50058 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676AbYGGV5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:57:51 -0400
X-Greylist: delayed 1279 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 17:57:50 EDT
Date: Mon, 7 Jul 2008 23:37:25 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Battery life difference
Message-ID: <20080707213725.GA28879@dose.home.local>
Mail-Followup-To: Kernel development list <linux-kernel@vger.kernel.org>
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com> <20080705082352.4b6be669@infradead.org> <31e679430807050844r30ff74fby7e15641573b42d82@mail.gmail.com> <20080706172159.GA12736@x61> <4871E67A.1040600@yahoo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4871E67A.1040600@yahoo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 11:48:42 +0200, Filippo Zangheri wrote:
> On 06/07/2008 19:21, Tino Keitel wrote:
> > On Sat, Jul 05, 2008 at 18:44:21 +0300, Felipe Balbi wrote:
> >> Hi,
> >>
> >> On Sat, Jul 5, 2008 at 6:23 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > [...]
> > 
> >>> Also take a look at
> >>> http://kerneltrap.org/mailarchive/linux-kernel/2008/5/8/1771024 because
> >>> these patches save like 0.75W in our lab.
> >> cool, is it merged upstream ?
> > 
> > If I got this right, at least Linux 2.6.25 allows to control this via
> > "/sys/class/scsi_host/host*/link_power_management_policy". Setting it
> > to "min_power" does the trick. This is also covered by powertop 1.10
> > and later.
> 
> I cannot see this on 2.6.25.9. Is there a particular configuration option
> you must enable, or it just didn't make it to 2.6.25?

All I can say is that I see it with 2.6.25.9 on a Thinkpad X61s with SATA
set to AHCI. See commit ca77329fb713b7fea6a307068e0dd0248e7aa640 for
details.

Regards,
Tino
