Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbYE2Rft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbYE2Rft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYE2Rfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:35:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:52763 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbYE2Rfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=ZvUqQ/fOtYgzK1pQBlGx1FNdpP0lzy2YvsR7kvwGTsQxfY+E93zeIr1hrc5vSUa6E7a6fR1GLuytTueZYmPJ0qCCoCHQBGQQZuf+qVKTY2qZZni2hxlHbV1RuJNDlDPxGJMxzIrl5wBv6SJgL/uW/T2lBDS98BkayWqvs0VqR0I=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify input subsystem interactions (v2)
Date: Thu, 29 May 2008 19:40:09 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805291919.04384.IvDoorn@gmail.com> <20080529172252.GB3375@khazad-dum.debian.net>
In-Reply-To: <20080529172252.GB3375@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291940.09563.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 29 May 2008, Ivo van Doorn wrote:
> > On Thursday 29 May 2008, Henrique de Moraes Holschuh wrote:
> > > On Thu, 29 May 2008, Ivo van Doorn wrote:
> > > > > This version better documents *_RFKILL_ALL.  Is it good enough for an
> > > > > ACK for patch 14 of 15?
> > > > 
> > > > Yes, you can put my ack on patch 14.
> > > > Thanks for the documentation update. :)
> > > 
> > > Then, this entire batch is ready for merging.  Now, if only Len would
> > > come back from wherever he disappeared to, in order to merge the two
> > > thinkpad-acpi patches, I could send it to netdev for merge.
> > 
> > Actually,  I believe the correct merge order would through wireless-dev,
> > which means the patches should go to John Linville and linux-wireless in the CC.
> 
> Noted.  At merge time (which will be as soon as the thinkpad-acpi
> changes hit mainline), I will send them to you, John, and
> linux-wireless.
> 
> Unless you want me to send them all right now to linux-wireless to see
> if there are any comments?

Well why wait with merging it into wireless-dev until thinkpad-acpi is merged?
I don't think there are real dependencies other then the SW_RFKILL_ALL define.
Perhaps you could send the rfkill patches with SW_RADIO instead of SW_RFKILL_ALL
and make the rename after the thinkpad and rfkill series have both been merged.
That would probably be the fastest route for this patch series.

Ivo
