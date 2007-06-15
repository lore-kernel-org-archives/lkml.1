Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbXFOTfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbXFOTfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXFOTey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:34:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:17180 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbXFOTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:34:53 -0400
Date: Fri, 15 Jun 2007 21:34:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Phillip Susi <psusi@cfl.rr.com>
cc: "R.F. Burns" <burnsrf@gmail.com>, Lee Revell <rlrevell@joe-job.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PC speaker
In-Reply-To: <4672C76D.5050008@cfl.rr.com>
Message-ID: <Pine.LNX.4.64.0706152131450.32724@fbirervta.pbzchgretzou.qr>
References: <a800cda90706120545w2c6d0bb0vb77bd4d961415c5c@mail.gmail.com> 
 <75b66ecd0706120744g7cdb3392l6537b5c68c2d6b21@mail.gmail.com>
 <a800cda90706121325p18c85b00r7bc4b15b95517371@mail.gmail.com>
 <4672C76D.5050008@cfl.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15 2007 13:07, Phillip Susi wrote:
> R.F. Burns wrote:
>> However, over the past several weeks, the students have found more
>> creative ways to abuse the PC speaker (outside of the OS.)  The Powers
>> that Be are asking that the PC speakers be disabled completely.  With
>> the small number of techs we have, it would be very impractical to go
>> around to all systems and remove the PC speaker from each and every
>> computer case.
>
> Now I am curious; how are they getting the pc speaker to make any sound with
> the kernel module disabled?

ioperm(), inb(), and outb() from userspace. Needs root, though. Or 
/dev/port, with write. Which comes to the question how they gained root. 
Perhaps live cd? In which case, the OP should, as recommended in this 
thread already, deactivate choosing boot devices, if that's possible.

(Unfortunately, newer BIOSes with 'integrated bootmenu' with F8 or so, 
but I have not seen a way to deactivate _that_ menu.)



	Jan
-- 
