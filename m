Return-Path: <linux-kernel-owner+w=401wt.eu-S1752382AbYE2ROw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbYE2ROw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbYE2ROe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:14:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:19858 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYE2ROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=pzen+u75nkeMW8JNSrok7FYR09sxZcRBUnDd8EiNsVfSepNF4aP3a5ZAutGYPezXPcqVMSEQPHpXdxL+AdTEaCVV+NBfuPrs14MmnHkFMm+aKSItUM4pSWWzUqRXwUsEJ65Okd1RwTSIesYoxn8nnyratLCqmpX0HCBijctX6Oc=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify input subsystem interactions (v2)
Date: Thu, 29 May 2008 19:19:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805291502.23726.IvDoorn@gmail.com> <20080529162625.GA3375@khazad-dum.debian.net>
In-Reply-To: <20080529162625.GA3375@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291919.04384.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 29 May 2008, Ivo van Doorn wrote:
> > > This version better documents *_RFKILL_ALL.  Is it good enough for an
> > > ACK for patch 14 of 15?
> > 
> > Yes, you can put my ack on patch 14.
> > Thanks for the documentation update. :)
> 
> Then, this entire batch is ready for merging.  Now, if only Len would
> come back from wherever he disappeared to, in order to merge the two
> thinkpad-acpi patches, I could send it to netdev for merge.

Actually,  I believe the correct merge order would through wireless-dev,
which means the patches should go to John Linville and linux-wireless in the CC.

> I will at least publish the entire stack as a thinkpad-acpi pre-release
> version, to get some testing on the real world with some power users.
> 
> I am thinking about how to best handle the global states.  Doing it
> through the rfkill class is ready, but the result was *UGLY*.  More on
> this later.

Ivo
