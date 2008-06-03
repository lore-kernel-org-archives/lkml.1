Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYFCT7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYFCT7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbYFCT7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:59:18 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:44164 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbYFCT7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:59:16 -0400
Date: Tue, 03 Jun 2008 21:59:13 +0200
Message-Id: <303013682@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: User-mode-linux-devel@lists.sourceforge.net, Jeff Dike <jdike@addtoit.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19qMArOIgQ5KH7VZzL++Cd1/VZs2ZI7LfjRMGylv61Jp1UkV
 dhignRfZYBNtgpaSCtfEpNhN8oabIzfS9joRGiArpDPhdST4/Q=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Protection against the host's time going backwards - keep track of the
>> time at the last tick and if it's greater than the current time, keep
>> time stopped until the host catches up.
>
>Strange.  What would cause the host's time (or at least UML's perception
>of it) to go backwards?

mhh - what about admin`s/user`s stupidity ?

e.g.

0 * * * *   root  /usr/sbin/ntpdate some.time.server >/dev/null 2>&1

in root`s crontab.

if the hosts`s clock is running faster than clock on some.time.server, this would set host`s clock back in time every hour or so....

common malpractice regarding time-syncronization - have seen that more than once.
(and have to admit that i used that some years ago before i wasn`t aware that ntpd does handle that more intelligent)


_______________________________________________________________________
EINE FÜR ALLE: die kostenlose WEB.DE-Plattform für Freunde und Deine
Homepage mit eigenem Namen. Jetzt starten! http://unddu.de/?kid=kid@mf2

