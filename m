Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYJGWr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYJGWr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbYJGWro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:47:44 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:48486 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755679AbYJGWrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:47:43 -0400
From: Frans Pop <elendil@planet.nl>
To: petkovbb@gmail.com
Subject: Re: CD tray closes spontaneously after opening it
Date: Wed, 8 Oct 2008 00:47:40 +0200
User-Agent: KMail/1.9.9
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Tony Vroon" <tony@vroon.org>,
       linux-kernel@vger.kernel.org, "Tejun Heo" <tj@kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>, Jiri Slaby <jirislaby@gmail.com>
References: <200809301247.05367.elendil@planet.nl> <200810011553.05318.elendil@planet.nl> <9ea470500810010702t5ff5e50di3c0182d0641c3dd5@mail.gmail.com>
In-Reply-To: <9ea470500810010702t5ff5e50di3c0182d0641c3dd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080047.41786.elendil@planet.nl>
X-OriginalArrivalTime: 07 Oct 2008 22:47:42.0517 (UTC) FILETIME=[B5331E50:01C928CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008, Boris Petkov wrote:
> I have a debugging infrastructure ready in ide-cd which is in Bart's
> tree, you could apply it ontop of current git, enable it and send dmesg
> so that we could see exactly what is going on:
>
> http://www.kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/

I have tried to reproduce this with the extra debugging, but have so far 
not been able to (which also explains the delay in replying).

There was one reply suggesting that the close could be triggered by 
the "user pushes tray in manually" sensor (which I had not thought of 
myself). I normally never do that, but when I fiddled with the tray it 
did close very quickly once. After that I did push it in a few times 
(with some force needed as you'd expect) and the problem has not 
reoccurred since.

So I'm currently inclined to blame that sensor as the cause of the 
problem, but will keep an open mind and try further tracing in case the 
problem reoccurs.

My thanks to all who responded and helped eliminate a number of possible 
causes.

Cheers,
FJP
