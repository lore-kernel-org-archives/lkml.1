Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYHTRRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYHTRRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYHTRQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:16:54 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37612 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYHTRQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:16:53 -0400
Subject: Re: CONFIG_KMOD breakage in next kernel
From: Marcel Holtmann <marcel@holtmann.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Johannes Berg <johannes@sipsolutions.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       video4linux-list@redhat.com
In-Reply-To: <s5h3akzwtki.wl%tiwai@suse.de>
References: <s5h3akzwtki.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 19:16:57 +0200
Message-Id: <1219252617.7591.350.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

> I found that CONFIG_KMOD was already removed in linux-next tree.
> This seems to result in many breakages.  For example, I cannot mount a
> FAT device automatically because of failure of automatic loading of
> nls modules.
> 
> My particular problem would be fixed by the patch below, but I found
> CONFIG_KMOD is still referred in many places.

I am happy to fix the net/bluetooth/ part, you someone has to put out a
guideline how this should be fixed.

Regards

Marcel


