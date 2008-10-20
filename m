Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYJTMMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYJTMMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYJTMM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:12:27 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:49610 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYJTMM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:12:26 -0400
Date: Mon, 20 Oct 2008 10:12:41 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: "Philip Stark" <heller.barde@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27 seems to break something with DSL
Message-ID: <20081020101241.456963cd@doriath.conectiva>
In-Reply-To: <c6740f810810110553q75478033ub984651d5509199b@mail.gmail.com>
References: <c6740f810810110553q75478033ub984651d5509199b@mail.gmail.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 11 Oct 2008 14:53:16 +0200
"Philip Stark" <heller.barde@gmail.com> escreveu:

| I'm sorry, I didn't lurk before making my first posting to this list,
| but it seemed to me that this might be an important problem/bug (if it
| is one).
| 
| first off, my network infrastructure:
| 
| "internet" --(magic*)-- DSL Modem --(DHCP)-- Router --(DHCP)-- Computer
| * PPPsomething i guess...
| 
| My observations so far:
| 
| with kernel =< 2.6.26 i can connect to the rest of the world perfectly
| (ping works and i can browse "the internet")
| 
| now with kernel 2.6.27, i.e with all the release candidates and also
| with the final version from yesterday i can ping anything just fine,
| but i can't browse. that is when i 'wget kernel.org' it resolves the
| address into the correct IP and then goes on to 'connecting' just to
| grind to a complete halt. after some time of course it times out.
| it seems to  be related to the packet  size because ping only seems to
| work because it uses small packets. if i increase the ping size up to
| 1000 bytes, it fails as well. (while it does work on 2.6.26)

 If you haven't solved this issue yet you could try:

# echo 0 > /proc/sys/net/ipv4/tcp_timestamps

 We (Mandriva) have had some reports of this issue and it seems that
some broken routers can drop packages because of the timestamp (that's
what our local network guy has said). Disabling timestamps make it work
again.

-- 
Luiz Fernando N. Capitulino
