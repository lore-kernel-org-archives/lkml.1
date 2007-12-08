Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbXLHJoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbXLHJoJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 04:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXLHJn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 04:43:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864AbXLHJn4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 04:43:56 -0500
Date: Sat, 8 Dec 2007 01:42:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland Dreier <rolandd@cisco.com>,
       Takashi Iwai <tiwai@suse.de>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-Id: <20071208014241.f4b138e0.akpm@linux-foundation.org>
In-Reply-To: <200712080340.49546.rjw@sisk.pl>
References: <200712080340.49546.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 03:40:49 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message contains a list of some regressions from 2.6.23 which have been
> reported since 2.6.24-rc1 was released and for which there are no fixes in the
> mainline that I know of.  If any of them have been fixed already, please let me
> know.
> 
> If you know of any other unresolved regressions from 2.6.23, please let me know
> either and I'll add them to the list.
> 
> ...
> 
> Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
> Submitter	: Roland Dreier <rdreier@cisco.com>
> References	: http://lkml.org/lkml/2007/11/8/255
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
> Handled-By	: 
> Patch		: 

Takashi had a patch and that has been merged.  AFAIK this regression
has been fixed and we're left with a new but harmless warning.

However Roland reported other problems and it appears that the trail went
cold (http://lkml.org/lkml/2007/11/14/251)

Ted was hitting some of the same problems but that trail appears to also
have gone cold (http://lkml.org/lkml/2007/11/23/17).

Guys, can we have a status update on all of this please?
