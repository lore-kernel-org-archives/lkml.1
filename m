Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbZB0Wyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbZB0Wyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbZB0Wyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:54:46 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43113 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbZB0Wyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:54:45 -0500
Message-ID: <49A86F2E.3080701@pobox.com>
Date: Fri, 27 Feb 2009 17:54:38 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avuton Olrich <avuton@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Linux IDE <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@pobox.com>
Subject: Re: DRDY ata message > 2.6.24.7-rt14, not before.
References: <3aa654a40902270944h3edeadf4pc9fb7587b76d7e9e@mail.gmail.com>
In-Reply-To: <3aa654a40902270944h3edeadf4pc9fb7587b76d7e9e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avuton Olrich wrote:
> ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> ata4.00: cmd 35/00:10:b0:70:75/00:00:1f:00:00/e0 tag 0 dma 8192 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)


Since you are seeing generic timeouts, without additional information, I 
would guess either a problem with interrupt delivery (not uncommon in 
-rt kernels) or you need to force your drives to 1.5Gbps.

	Jeff


