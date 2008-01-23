Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYAWHlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYAWHlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 02:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYAWHlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 02:41:25 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41532 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbYAWHlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 02:41:23 -0500
Date: Wed, 23 Jan 2008 09:41:20 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: hidave.darkstar@gmail.com
cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1 : net tcp_input.c warnings
In-Reply-To: <20080122.190137.206066966.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0801230937270.31652@kivilampi-30.cs.helsinki.fi>
References: <a8e1da0801220109v6bf8931ev50f2210402c3ba41@mail.gmail.com>
 <Pine.LNX.4.64.0801221115150.31652@kivilampi-30.cs.helsinki.fi>
 <a8e1da0801221744m37021e88h5c188e5b31ea42bf@mail.gmail.com>
 <20080122.190137.206066966.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-172326771-1201074080=:31652"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-172326771-1201074080=:31652
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 22 Jan 2008, David Miller wrote:

> From: "Dave Young" <hidave.darkstar@gmail.com>
> Date: Wed, 23 Jan 2008 09:44:30 +0800
> 
> > On Jan 22, 2008 6:47 PM, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
> > > [PATCH] [TCP]: debug S+L
> > 
> > Thanks, If there's new findings I will let you know.
> 
> Thanks for helping with this bug Dave.

I noticed btw that there thing might (is likely to) spuriously trigger at 
WARN_ON(sacked != tp->sacked_out); because those won't be equal when SACK 
is not enabled. If that does happen too often, I send a fixed patch for 
it, yet, the fact that I print print tp->rx_opt.sack_ok allows
identification of those cases already as it's zero when SACK is not 
enabled.

Just ask if you need the updated debug patch.

-- 
 i.
---696243703-172326771-1201074080=:31652--
