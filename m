Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbYEGRWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbYEGRWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYEGRWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:22:02 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57445 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752402AbYEGRWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:22:00 -0400
Date: Wed, 7 May 2008 10:21:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?ISO-8859-1?Q?St=E9phane_ANCELOT?= <sancelot@free.fr>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: detecting kernel mem leak
In-Reply-To: <4821C526.8030901@free.fr>
Message-ID: <Pine.LNX.4.64.0805071020210.3173@schroedinger.engr.sgi.com>
References: <1209462094.4816ed4e93977@imp.free.fr>
 <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com>
 <Pine.LNX.4.64.0804290956360.10847@schroedinger.engr.sgi.com>
 <4821C526.8030901@free.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-647866999-1210180919=:3173"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-647866999-1210180919=:3173
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 7 May 2008, St=E9phane ANCELOT wrote:

> however, since there are always cache filled,=A0 is there a way to flush=
=20
> all cashes and then consult slabinfo with caches empty ???

Not sure what this is about. per cpu cached objects?

slabinfo -s

will shrink all caches and throw all cpu slabs away. The system will touch=
=20
some essential caches immediately though. So some processor will=20
immediately reallocate cpu slabs.


---1700579579-647866999-1210180919=:3173--
