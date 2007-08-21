Return-Path: <linux-kernel-owner+w=401wt.eu-S1762737AbXHURrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762737AbXHURrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758330AbXHURrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:47:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:44670 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbXHURrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LtToFBbX/Xigvxt2XzkhnW97DwBQ4Bm4uMuOXKib0lqdln/69kRmNjfTT4kWvtRqkLcEw/FyAml505yby/WVgqgTj6ODNKLffY16MWWthCU3mTylpFy6zCTDShXu3tRZwjuevxtAJ7vVt4h0LJuPHW5Uzhf1Cn4zZdTLQSTVsr0=
Message-ID: <5d6222a80708211047x1393524j962afc0a02af5ba3@mail.gmail.com>
Date: Tue, 21 Aug 2007 14:47:21 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Christian Borntraeger" <borntraeger@de.ibm.com>
Subject: =?ISO-8859-1?Q?Re:_[kvm-devel]_R=E9f._:_Re:_[PATCH_0?= =?ISO-8859-1?Q?/4]_Virtual_Machine_Time_Accounting?=
Cc: kvm-devel@lists.sourceforge.net,
       "laurent.vivier@bull.net" <laurent.vivier@bull.net>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "John Stoffel" <john@stoffel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <200708211006.42938.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OF945F7B1F.FF4B4672-ONC125733D.006266E7-C125733D.00626843@frec.bull.fr>
	 <5d6222a80708201334q27fc6cbcr7ce6a9d7147437a2@mail.gmail.com>
	 <200708211006.42938.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> Am Montag, 20. August 2007 schrieb Glauber de Oliveira Costa:
> > Although I don't know KVM to a that deep level, I think it should be
> > possible to keep the virtual cpus in different process (or threads),
> > and take the accounting time from there. Perfectly possible to know
> > the time we spent running (user time), and the time the hypervisor
> > spent doing things on our behalf (system time).
>
> I disagree here. First thing, you dont want to have the virtual cpu in a
> different process than the hypervisor control code for that cpu. Otherwise
> communication has to be made via IPC.
> Secondly, Its not qemu/kvm that does the accouting. Its existing userspace
> code like top/snmp agents and clients! etc. that would require additional
> knowledge which thread is guest code.

Yes, the second argument kills me, and I think it leaves no further
room from discussion in my side. Thanks for the enlightenment.

> I personally like the approach Laurent has taken. Maybe it needs some polish
> and maybe we want an account_guest_time function, but in general I think he
> is doing the right thing.
>
Now, me too.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
