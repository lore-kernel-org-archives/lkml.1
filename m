Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbYGJJZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbYGJJZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYGJJZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:25:39 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:34784 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbYGJJZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:25:38 -0400
From: Frans Pop <elendil@planet.nl>
To: Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [regression?] 2.6.26 floppy boot failure with kernel packed using 'upx'
Date: Thu, 10 Jul 2008 11:25:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200807100655.00857.elendil@planet.nl> <1215676061.3452.29.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1215676061.3452.29.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807101125.34275.elendil@planet.nl>
X-OriginalArrivalTime: 10 Jul 2008 09:25:34.0622 (UTC) FILETIME=[E7F963E0:01C8E26E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008, Ian Campbell wrote:
> On Thu, 2008-07-10 at 06:54 +0200, Frans Pop wrote:
> > The issue can also be reproduced using qemu without booting the
> > floppy itself. For the "bad" image:
> > # Boots correctly (but fails when mounting root fs):
> > $ qemu -kernel vmlinuz -hda /dev/zero
> > # Fails:
> > $ qemu -kernel vmlinuz.upx -hda /dev/zero
>
> I can repro this.
>
> All in all I'd say it should be treated as a new subtype/variant which
> UPX should support. I'd say adding support for bzImage v2.08 to UPX
> would be pretty easy for someone who knows the code base (I couldn't
> even find the decompressor code, but then it's pre-coffee time here..).

Thanks for the quick and complete reply Ian. I already expected this but 
thought it would at least be useful to inform people here of the issue 
(and get it indexed for search engines).

I have no problems with it not being treated as a bug/regression.

I've now filed a bug report against upx:
http://sourceforge.net/tracker/?func=detail&aid=2014835&group_id=2331&atid=102331

Cheers,
FJP
