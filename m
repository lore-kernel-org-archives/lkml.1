Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZLUS5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZLUS5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 13:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZLUS5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 13:57:53 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34033 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZLUS5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 13:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NDvOCyN+BbISIDnsYceTWM1TSViwCuvSXVkZ/56rKNeyoSMjsZk4sIGmpN0zX2ogWW
         Os6E/Lq6fh590KwhQ5lz+66yfKDyCGPzNNQ/lFNiZTYve1pwPx17ZhAX0LpH+vBj6M4I
         3cH0AQvqEgoQwHGL3u9+mqEGBAcMq6B5DPlNY=
Message-ID: <4B2FC527.2010301@garzik.org>
Date: Mon, 21 Dec 2009 13:57:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] libata: pata_bf54x: handle portmuxing of pins through
 GPIO PORTs
References: <1247593187-26570-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1247593187-26570-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2009 01:39 PM, Mike Frysinger wrote:
> From: Sonic Zhang<sonic.zhang@analog.com>
>
> By default, the PATA pins are routed to the async address lines in which
> case, no peripheral muxing needs to be done.  However, if the pins get
> routed through the GPIO PORTs pins, we need to make sure to request them
> so that the muxing is properly set up.
>
> Signed-off-by: Sonic Zhang<sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu<cooloney@kernel.org>
> Signed-off-by: Mike Frysinger<vapier@gentoo.org>
> ---
> Andrew: could you pick this up ?  it was posted over a month ago to the
> Linux/IDE list w/no feedback.
>
>   drivers/ata/pata_bf54x.c |   19 +++++++++++++++++++
>   1 files changed, 19 insertions(+), 0 deletions(-)


Added to the tip of libata-dev...

Linus, if you pull

master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git 
upstream-linus

then you will receive the previous pull (two pata_cmd64x fixes), plus 
the above fix to pata_bf54x.

