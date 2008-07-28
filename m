Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbYG1Sww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbYG1Sww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbYG1Swk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:52:40 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41729 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbYG1Swj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:52:39 -0400
X-Sasl-enc: EQLXNB6ny6WLiZyBFjlXGjDImBivmhEnqz7W67N6HY/j 1217271157
Date: Mon, 28 Jul 2008 15:52:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: Philip Langdale <philipl@overt.org>, Ivo van Doorn <ivdoorn@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, toshiba_acpi@memebeam.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill
Message-ID: <20080728185233.GB26564@khazad-dum.debian.net>
References: <488CBBAB.6010508@overt.org> <200807272259.44364.IvDoorn@gmail.com> <488CF6D8.6000700@overt.org> <20080728030437.GC10672@khazad-dum.debian.net> <1217243863.24609.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217243863.24609.6.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008, Dan Williams wrote:
> On Mon, 2008-07-28 at 00:04 -0300, Henrique de Moraes Holschuh wrote:
> > On Sun, 27 Jul 2008, Philip Langdale wrote:
> > > Ivo van Doorn wrote:
> > >> You don't seem to be using rfkill_force_state() which is required to inform the rfkill
> > >> layer about the state changes.
> > >
> > > Hmm? According to rfkill.txt, one can either use force_state() or implement the
> > > get_state() hook, and I have done the later. If this is not the correct method,
> > > can you please explain when I should be using force_state?
> > 
> > There is a bunch of rfkill bug fix patches that was not merged in
> > wireless-testing yet (which is a pity, it would be really good if they could
> > go into 2.6.27).  One of those patches fixes the docs to make it clear that
> 
> Lots of wireless people (including John) were at OLS this past week, so
> it's not entirely surprising that patch merging might have been slow.

That would explain it, yes...  Well, I sure hope this means the patches
still have a non-zero chance of being sent to mainline for 2.6.27 :-)  I am
not up to date on how merges are usually handled in the wireless and net
subsystems.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
