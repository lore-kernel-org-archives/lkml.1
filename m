Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbYFLPA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbYFLPA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYFLPAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:00:15 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:36486 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYFLPAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:00:13 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: "Phil Endecott" <phil_tuhck_endecott@chezphil.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <marcel@holtmann.org>, <jkosina@suse.cz>
Subject: Re: [PATCH] [RESEND] fix HID quirks for aluminium apple wireless keyboards
References: <874p7ylsj0.fsf@burly.wgtn.ondioline.org>
	<1213276636216@dmwebmail.dmwebmail.chezphil.org>
Date: Fri, 13 Jun 2008 02:55:43 +1200
In-Reply-To: <1213276636216@dmwebmail.dmwebmail.chezphil.org> (Phil Endecott's
	message of "Thu, 12 Jun 2008 14:17:16 +0100")
Message-ID: <87prqmk8i8.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Phil Endecott" <phil_tuhck_endecott@chezphil.org> writes:

> Did you see my messages about this a few weeks ago?  
> http://thread.gmane.org/gmane.linux.kernel.input/4984

Alas, no!  That would have been very helpful.

> I didn't post a patch because I believe that this stuff has all moved
> as a result of Jiri Slaby's patch "HID: move apple quirks" posted to
> linux-input on 2008-05-16.  One of us should prepare a patch against
> the tree after that patch.

I'm happy to do this, although the only tree I track closely is Linus's.

> Do you know what happens if you have a USB bluetooth dongle with HID
> proxy mode?  My assumption was that the vendor and product IDs from
> the keyboard would then appear to the kernel as USB IDs.  If this is
> true, then you should keep the existing entries for these devices in
> the USB quirks tables.  Does anyone know if HID proxy dongles actually
> do this?  In any case, leaving the existing entries in the USB quirks
> table can't do any harm.

Hmm, no idea.  Absent confirmation I guess I'll drop the USB HID changes
to be on the safe side.

> I wrote this up at http://chezphil.org/apple-alu-bluetooth-kb-linux/
> and I'll just post that URL again to help the search engines...

Nice writeup!  Small correction: when the quirk is active, you can
generate forward delete by pressing Fn-backspace.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
