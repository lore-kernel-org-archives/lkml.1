Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbXHTT10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbXHTT10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXHTT1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:27:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbXHTT1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:27:09 -0400
Message-ID: <46C9EAFC.6090301@redhat.com>
Date: Mon, 20 Aug 2007 21:26:52 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       Paul Mundt <lethal@linux-sh.org>, Mike Frysinger <vapier.adi@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ensure we don't use bootconsoles after init has been
 released
References: <200708192246.05783.rgetz@blackfin.uclinux.org> <8bd0f97a0708192011m1b957e57je313850a255dcac7@mail.gmail.com> <20070820033143.GA4918@linux-sh.org> <200708201522.47591.rgetz@blackfin.uclinux.org>
In-Reply-To: <200708201522.47591.rgetz@blackfin.uclinux.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote:
> This ensures that a bootconsole is unregistered if it is not replaced.
> The current implementation spews garbage out the bootconsole in this case,
> since the bootconsole structure is normally in the init section, and is
> freed, but still used.
>  
> Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
> CC: Gerd Hoffmann <kraxel@redhat.com>

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

cheers,
  Gerd

