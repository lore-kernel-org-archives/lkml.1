Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbXFAMTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbXFAMTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXFAMTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:19:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:60443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbXFAMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:19:30 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: SELECT() returns 1 But FIONREAD says (Input/output error)
To: Uncle George <netbeans@gatworks.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 01 Jun 2007 14:19:04 +0200
References: <8qXzx-jY-31@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Hu65z-0000wG-9a@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18bUNc35GDctDOZwMmWSY4fRcj8O+UxcKklWfh
 m84KVsnMBGGWi9w8x4IYpC0lqeB1Ue4bdHDgconPo0335gVybc
 DErHsIdbyRrjg8vQCFw7g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uncle George <netbeans@gatworks.com> wrote:

> i am using the GARMIN_GPS/usb driver to read a gps receiver.
> In testing the ability of my software to recover from various errors, I
> try this: unplug the gps/USB cable from the usb hub.
> 
> Interestingly enough the thread spins.
> the SELECT() waits for something to happen, and I get one channel that
> something interesting happened.

Or, more precisely, that you won't have to wait for an event.

> Needless to day, the code resets the SELECT parameters, and SELECT is 
> called again. It again says that something interesting has happened on 
> that ( i/o errored ) channel. And we now repeat the††FIONREAD.

That's exactly what select promised you'd get.
-- 
Today's assembler command: EXOP Execute Operator 

Friﬂ, Spammer: huirt@mQqfrym.7eggert.dyndns.org t@FarcIkc.7eggert.dyndns.org
 wV1uda@wV.7eggert.dyndns.org ycsryPljcb@kj.7eggert.dyndns.org
