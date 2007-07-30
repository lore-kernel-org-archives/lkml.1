Return-Path: <linux-kernel-owner+w=401wt.eu-S967674AbXG3SLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967674AbXG3SLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966654AbXG3SLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:11:11 -0400
Received: from smtp101.plus.mail.mud.yahoo.com ([68.142.206.234]:23614 "HELO
	smtp101.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966696AbXG3SLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:11:09 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 14:11:09 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=IY7J/H8pPvlpWUhwUFrS1I7KRoSx6e+DN/RBxxNDzTDHH0D9aZqDXSAK7Jie3/O4rRi99KO4vPkZ9nBlTNGxOErdZEPFgJ82fyG4TfrwrdoEAkTXP1gweaECwVovHbKxODV6gi9jHCwRvMQmiSBBeZnyBStECynmwM1ShF/VEmk=  ;
X-YMail-OSG: mKU6vOIVM1nX_SnOFt5F8Un2o38ZrM0ENMYR5Ttvm9sOeMREh60ATxytIIzSEbAa0pOQi80F9sB4q0pRG9ppX_2czTW76Lb.siy5DlOSOG59vB4Uw2Q-
Date: Mon, 30 Jul 2007 20:03:24 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andre Noll <maan@systemlinux.org>,
       Wim Van Sebroeck <wim@iguana.be>, Bret Towe <magnade@gmail.com>,
       Nick Piggin <npiggin@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jakub Jelinek <jakub@redhat.com>, Eric Sesterhenn <snakebyte@gmx.de>,
       Sid Boyce <g3vbv@blueyonder.co.uk>
Subject: Re: [1/3] 2.6.23-rc1: known regressions v3
Message-ID: <20070730180324.GA5163@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <46AE12EE.1070501@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46AE12EE.1070501@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 06:33:50PM +0200, Michal Piotrowski wrote:
Hi,

> Hi all,
> 
> Here is a list of some known regressions in 2.6.23-rc1.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> List of Aces
> 
> Name                    Regressions fixed since 21-Jun-2007
> Adrian Bunk                            6
> Andi Kleen                             4
> Andrew Morton                          4
> Linus Torvalds                         4
> Al Viro                                3
> Jens Axboe                             3
> Tejun Heo                              3
> David Woodhouse                        2
> Hugh Dickins                           2
> 
> 
> 
> Unclassified
> 
> Subject         : 2.6.23-rc1-git3 init failure
> References      : http://lkml.org/lkml/2007/7/26/467
> Last known good : 2.6.23-rc1-git1
> Submitter       : Sid Boyce <g3vbv@blueyonder.co.uk>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown
> 
> Subject         : Time Problems with 2.6.23-rc1-gf695baf2
> References      : http://lkml.org/lkml/2007/7/23/486
> Last known good : ?
> Submitter       : Eric Sesterhenn <snakebyte@gmx.de>
> Caused-By       : ?
> Handled-By      : ?
> Status          : problem is being debugged
> 
> Subject         : 2.6.23-rc1 regression: mm: fix fault vs invalidate race for linear mappings
> References      : http://lkml.org/lkml/2007/7/24/301
> Last known good : ?
> Submitter       : Bret Towe <magnade@gmail.com>
> Caused-By       : Nick Piggin <npiggin@suse.de>
>                   commit d00806b183152af6d24f46f0c33f14162ca1262a
> Handled-By      : ?
> Status          : unknown
> 
> Subject         : no setup signature found...
> References      : http://lkml.org/lkml/2007/7/24/168
> Last known good : ?

you can put here 2.6.22

> Submitter       : Borislav Petkov <bbpetkov@yahoo.de>
> Caused-By       : H. Peter Anvin <hpa@zytor.com>
>                   commit 4fd06960f120e02e9abc802a09f9511c400042a5
> Handled-By      : H. Peter Anvin <hpa@zytor.com>
> Status          : problem is being debugged
> 
> Subject         : /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
> References      : http://lkml.org/lkml/2007/7/22/239
> Last known good : ?
> Submitter       : Andre Noll <maan@systemlinux.org>
> Caused-By       : ?
> Handled-By      : Andi Kleen <ak@suse.de>
>                   Jakub Jelinek <jakub@redhat.com>
> Status          : problem is being debugged
> 
> 
> 
> Regards,
> Michal
> 
> --
> LOG
> http://www.stardust.webpages.pl/log/

-- 
Regards/Gruﬂ,
    Boris.
