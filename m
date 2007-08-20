Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbXHTUjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbXHTUjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765613AbXHTUe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:34:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:63622 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765612AbXHTUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=grzaSji6xvuUkp5vpqvIiguQV11tS6CBj3hvOa3mDxSNT4/myqoSTK+n/K3cn5yjb1nOVTnQwHyZOMpdbfraY8mewehtlywwi/C7JHQHE5pEzESr5AXJyRfcshY8TU+mZ24f3qenSFrlt8R9iynOvVZsFeG/iuaPWqF7MkuSr3M=
Message-ID: <5d6222a80708201334q27fc6cbcr7ce6a9d7147437a2@mail.gmail.com>
Date: Mon, 20 Aug 2007 17:34:49 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "laurent.vivier@bull.net" <laurent.vivier@bull.net>
Subject: =?ISO-8859-1?Q?Re:_R=E9f._:_Re:_[PATCH_0/4]_Vi?= =?ISO-8859-1?Q?rtual_Machine_Time_Accounting?=
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "John Stoffel" <john@stoffel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <OF945F7B1F.FF4B4672-ONC125733D.006266E7-C125733D.00626843@frec.bull.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OF945F7B1F.FF4B4672-ONC125733D.006266E7-C125733D.00626843@frec.bull.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> by doing this at kernel level, we can:
> - measure exactly the guest time,
> - move this part of system time to user time (as you think it should be
> user time),
> - have consistency between system, user and guest time,
> - report values in /proc/state and /proc/<pid>/state, at system wide level
>
> I'm not sure we can measure the guest time at the qemu user level.
>
> Perhaps Rusty can say what he thinks about this ?
>
Even if we cannot _now_, isn't that an easier, and safer change? (and
I don't think we lose anything by design).

Although I don't know KVM to a that deep level, I think it should be
possible to keep the virtual cpus in different process (or threads),
and take the accounting time from there. Perfectly possible to know
the time we spent running (user time), and the time the hypervisor
spent doing things on our behalf (system time).

$0.02.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
