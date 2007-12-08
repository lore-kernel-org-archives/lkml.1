Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbXLHS6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbXLHS6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbXLHS6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:58:01 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:37229 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXLHS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:58:00 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland Dreier <rolandd@cisco.com>,
       Takashi Iwai <tiwai@suse.de>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
X-Message-Flag: Warning: May contain useful information
References: <200712080340.49546.rjw@sisk.pl>
	<20071208014241.f4b138e0.akpm@linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 08 Dec 2007 10:57:57 -0800
In-Reply-To: <20071208014241.f4b138e0.akpm@linux-foundation.org> (Andrew Morton's message of "Sat, 8 Dec 2007 01:42:41 -0800")
Message-ID: <adawsrp9fpm.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Dec 2007 18:57:58.0222 (UTC) FILETIME=[3F8A9EE0:01C839CC]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
 > > Submitter	: Roland Dreier <rdreier@cisco.com>
 > > References	: http://lkml.org/lkml/2007/11/8/255
 > > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
 > > Handled-By	: 
 > > Patch		: 
 > 
 > Takashi had a patch and that has been merged.  AFAIK this regression
 > has been fixed and we're left with a new but harmless warning.
 > 
 > However Roland reported other problems and it appears that the trail went
 > cold (http://lkml.org/lkml/2007/11/14/251)

A fix for the most likely cause of this problem was merged (7eba5c9d
"[ALSA] hda-codec - Check PINCAP only for PIN widgets") but it seems
that setting CONFIG_SND_HDA_POWER_SAVE can cause the "azx_get_response
timeout, switching to polling mode" message sometimes too.  However
according to Takashi this is really just a cosmetic problem -- polling
mode is not so bad.

 - R.
