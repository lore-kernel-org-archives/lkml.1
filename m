Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbXJJXn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbXJJXn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 19:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXJJXnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 19:43:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583AbXJJXnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:43:21 -0400
Date: Wed, 10 Oct 2007 16:42:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Markus Rechberger <mrechberger@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
In-Reply-To: <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710101639550.20690@woody.linux-foundation.org>
References: <1192053794.15601.47.camel@gaivota>
 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Oct 2007, Markus Rechberger wrote:
> 
> the chances of the em28xx are not accepted from my side since the latest code
> which supports way more hardware is offtree for various reasons.

Well, I've talked to various people, and none of the main kernel people 
end up being at all interested in a kernel that has external dependencies 
on binary blobs for tuners.

So right now it seems like while I would personally want to have more 
vendors supprt their own drivers, if that in this case means that we'd 
have to have user-space and unmaintainable binaries to tune the cards, 
everybody seems to hate that idea. 

As such, the old and decrepit em28xx driver seems more useful to people, 
since at least it supports the limited set of hardware on its own.

		Linus
