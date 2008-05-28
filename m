Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYE1GON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYE1GON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 02:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYE1GN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 02:13:59 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1464 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbYE1GN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 02:13:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Subject: Re: [PATCH] video4linux: Push down the BKL
Date: Wed, 28 May 2008 08:13:51 +0200
User-Agent: KMail/1.9.7
Cc: "Devin Heitmueller" <devin.heitmueller@gmail.com>,
       "Andy Walls" <awalls@radix.net>, Jonathan Corbet <corbet@lwn.net>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20080522223700.2f103a14@core> <1211932138.3197.29.camel@palomino.walls.org> <412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
In-Reply-To: <412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805280813.51909.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008 02:46:22 Devin Heitmueller wrote:
> Hello Andy,
>
> On Tue, May 27, 2008 at 7:48 PM, Andy Walls <awalls@radix.net> wrote:
> > MythTV's mythbackend can open both sides of the card at the same
> > time and the cx18 driver supports it.  On my HVR-1600, MythTV may
> > have the digital side of the card open pulling EPG data off of the
> > ATSC broadcasts, when I open up the MythTV frontend and start
> > watching live TV on the analog side of the card.  MythTV also
> > supports
> > Picture-in-Picture using both the analog and digital parts of the
> > HVR-1600.
>
> In this case, what you see as a 'feature' in MythTV is actually a
> problem in our case.  While the HVR-1600 can support this scenario,

Actually, it depends on how the card was defined. There are cards that 
only utilize the analog part of the cx23418, cards that can do both 
digital and analog at the same time and cards that can do either 
digital or analog. The cx18 driver supports the first two cases but not 
yet the last.

Regards,

	Hans
