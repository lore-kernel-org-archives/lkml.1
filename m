Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbXEIKlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbXEIKlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXEIKlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:41:16 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:50252 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXEIKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:41:15 -0400
Date: Wed, 9 May 2007 12:41:14 +0200
From: folkert <folkert@vanheusden.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.21] kernel panic
Message-ID: <20070509104113.GI17230@vanheusden.com>
References: <20070506115651.GA13183@vanheusden.com> <Pine.LNX.4.64.0705061632500.16923@twin.jikos.cz> <20070506164944.GA15682@vanheusden.com> <Pine.LNX.4.64.0705070029580.16923@twin.jikos.cz> <Pine.LNX.4.64.0705091221360.16923@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705091221360.16923@twin.jikos.cz>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Wed May  9 18:34:54 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a key-signing at www.biglumber.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > OK, I think the patch below should solve this. I am pretty surprised 
> > though that this bug wasn't triggered/reported by anyone anytime sooner, 
> > it has been there for ages too (but ok, the race window should be pretty 
> > small and hiddev is usually not high-throughput interface).
> > Could you please test it and let me know?
> > From: Jiri Kosina <jkosina@suse.cz>
> > USB HID: hiddev - fix race between hiddev_send_event() and hiddev_release()
> did you have time to verify whether this patch fixes the issue for you?

It looks like this solves the hid-problem. But I still get the
occasional 'not responding but still forwarding network-traffic(!)' and
'ext3 circular lock failure' problems.


Folkert van Heusden

-- 
To MultiTail einai ena polymorfiko ergaleio gia ta logfiles kai tin
eksodo twn entolwn. Prosferei: filtrarisma, xrwmatismo, sygxwneysi,
diaforetikes provoles. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
