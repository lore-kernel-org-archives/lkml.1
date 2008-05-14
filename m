Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbYENHfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbYENHfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYENHfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:35:00 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:22807 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYENHe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B2QTw8/7ELlRSnpVNaiDlD3Te8gyUNXhktD6XqMyb466gwG/D1LYbsJy5EWqDQ8eTiQymtKKzq+s7Yn2xTnDyaQsbMUWUUU9yq7Y8plfvZvJPmX22rUk6fFeJyr8lQD7RWshYlq2DEWDNEeVLVvLVD2gX4uTV5Y9wb9kbUs3z3s=
Message-ID: <19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com>
Date: Wed, 14 May 2008 09:34:57 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Harald Dunkel" <harald.dunkel@t-online.de>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4829D345.7020909@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4829326A.6060808@t-online.de>
	 <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>
	 <4829D345.7020909@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 7:43 PM, Harald Dunkel
<harald.dunkel@t-online.de> wrote:
> Vegard Nossum wrote:
>
> > Can you try to run "strace su someuser" instead?
>
>  I tried, but its a Heisenbug: If I run it with strace (with or without
>  -f), then it doesn't get stuck.

Ah, tough luck. What if you attach an strace to the already stuck
process? Like strace -p pid. It's a long shot, but worth a try, I
suppose.

You could also try to use sysrq to output some useful information
about the stuck process. See Documentation/sysrq.txt for more
information. Gotta run, good luck!

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
