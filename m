Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbXLRIEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbXLRIEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 03:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXLRIE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 03:04:28 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:50663 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbXLRIE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 03:04:27 -0500
Date: Tue, 18 Dec 2007 09:04:24 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Kyungmin Park" <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][MMC] Fix wrong EXT_CSD_REV handling
Message-ID: <20071218090424.19729464@poseidon.drzeus.cx>
In-Reply-To: <9c9fda240712131801w5aec854eg71f3dc7ad49ddeb@mail.gmail.com>
References: <20071213071311.GA2970@party>
	<20071213085332.18d2790d@poseidon.drzeus.cx>
	<9c9fda240712130008s227a77dsbd9333c5227d51eb@mail.gmail.com>
	<20071213092437.7aa2b928@poseidon.drzeus.cx>
	<9c9fda240712131801w5aec854eg71f3dc7ad49ddeb@mail.gmail.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 11:01:03 +0900
"Kyungmin Park" <kmpark@infradead.org> wrote:

> 
> Yes, reserved word should or must be zero, then it should check "if
> (ext_csd_struct <= 2)" instead of ">= 2".
> In the Spec. 4.2, it can have three value 0, 1, or 2. There's no other
> restriction.

As I said, the spec doesn't say "must", and I've seen cards with bogus data in there so I'm afraid we can't rely on the fields being zero. The version field is the only decent way of determining what to expect in the rest of the structure.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
