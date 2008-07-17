Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbYGQQ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbYGQQ0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbYGQQ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:26:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47098 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758202AbYGQQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:26:35 -0400
X-Sasl-enc: zlIw1Dkm8+IlVlAYTy63KF8CQx81IHc6EohpVw2yco3T 1216311993
Date: Thu, 17 Jul 2008 13:26:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: alan-jenkins@tuffmail.co.uk, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other
	GPEs) on Asus EeePC
Message-ID: <20080717162628.GB18457@khazad-dum.debian.net>
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de> <20080717121309.GF31732@khazad-dum.debian.net> <487F3B6D.3090507@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487F3B6D.3090507@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Alexey Starikovskiy wrote:
> Henrique de Moraes Holschuh wrote:
>> On Thu, 17 Jul 2008, Alexey Starikovskiy wrote:
>>> Thanks for the patch, ACK.
>>
>> This one fixes a potentially bad problem, since we could ignore more than
>> just hot key EC events by accident.  Maybe it should go to -stable?
>
> I vote for it

Well, in that case, it would be best to tack a Cc: stable@kernel.org git
footer to it right away, I think.

IMHO, it would also be nice if the commit message made it more clear that
the issue it solves can affect much more serious ACPI events than just hot
key presses.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
