Return-Path: <linux-kernel-owner+w=401wt.eu-S936589AbZDCUQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936589AbZDCUQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760611AbZDCUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:16:08 -0400
Received: from iona.labri.fr ([147.210.8.143]:48790 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098AbZDCUQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:16:07 -0400
Message-ID: <49D66E83.5070606@inria.fr>
Date: Fri, 03 Apr 2009 22:16:03 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Chris Worley <worleys@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>
In-Reply-To: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Worley wrote:
> Sorry for an off topic, but I'm hoping somebody can point me in the
> right direction of where to direct this question...
>
> I have an Opteron system where I've seen the HW diagrams, and each of
> 4 sockets is directly connected (HT) to two other sockets, and two HT
> hops away from a third (i.e. a simple square topology, no X in the
> middle).
>
> Yet, "numactl --hardware" shows but one hop to each socket:
>
> # numactl --hardware
> ...
> node   0   1   2   3
>   0:  10  20  20  20
>   1:  20  10  20  20
>   2:  20  20  10  20
>   3:  20  20  20  10
>
> I know this is wrong.
>
> Who would be the right person (or list) to talk about this?
>   

IIRC, the motherboard/BIOS is supposed to report numa distances through
the PXM ACPI method. But I have never seen any opteron box do it
properly. So you just get 10 for "local" and 20 for "remote". Some
Itanium machines however report actual distances.

Brice

