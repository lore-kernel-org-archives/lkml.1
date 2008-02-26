Return-Path: <linux-kernel-owner+w=401wt.eu-S1764686AbYBZVfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764686AbYBZVfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762872AbYBZVfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:35:20 -0500
Received: from styx.suse.cz ([82.119.242.94]:51689 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765573AbYBZVfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:35:18 -0500
Date: Tue, 26 Feb 2008 22:35:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?UTF-8?Q?Szekeres_Istv=C3=A1n?= <szekeres@iii.hu>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel losing printk messages?
In-Reply-To: <f4fe1c2a0802261314i5c4c5738y2a3f0e1c8748ee60@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802262233290.30955@jikos.suse.cz>
References: <f4fe1c2a0802261309s17aaf082w14525c1e2f3af2f@mail.gmail.com>
 <f4fe1c2a0802261314i5c4c5738y2a3f0e1c8748ee60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-1040306368-1204061717=:30955"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-1040306368-1204061717=:30955
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 26 Feb 2008, Szekeres Istv=E1n wrote:

> in 2.6.25-rc3 I'm trying to add support for an usb keyboard. While the=20
> hid-input driver dumps a lot of debugging messages, lines seem to be=20
> lost. Please see the lines shorter/longer than the average.

Hi,

I don't see this on 2.6.25-rc3. Does this happen only on boot? What if you=
=20
do

=09rmmod usbhid
=09rmmod hid
=09modprobe hid debug=3D1
=09modprobe usbhid

on already booted system?

> This is directly copied from /var/log/kern.log.

I guess in dmesg the output is also corrupted, right?

> Is this a bug or a feature? :)

It would be a sad feature indeed :)

--=20
Jiri Kosina
SUSE Labs
--336216065-1040306368-1204061717=:30955--
