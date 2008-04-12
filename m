Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbYDLNPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbYDLNPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 09:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYDLNPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 09:15:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:14592 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYDLNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 09:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=tZ08H4U52JaSfEB/fDHEXKEkUxuqaY/dASxEDyQaD7noRIeJu0uAvl7CWtMaYO4oDq5liRmno2V6Q9ZM/j8u7LH5n35vm9c4J33sG4Bkj8fPh/8dtjJXvjpRO4b0QSNap+RrsWx5jjHRgOIZggksq5kETq5pyDHUGZiw23FKesI=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Date: Sat, 12 Apr 2008 15:17:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121423.59988.IvDoorn@gmail.com> <20080412130845.GD3402@khazad-dum.debian.net>
In-Reply-To: <20080412130845.GD3402@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121517.07177.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> > > On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > > > On Friday 11 April 2008, Henrique de Moraes Holschuh wrote:
> > > > > The *_RADIO input events are related to all radios in a system.  There are
> > > > > two: KEY_RADIO and SW_RADIO.
> > > > > 
> > > > > Teach rfkill-input how to handle them.  In particular, SW_RADIO is not a
> > > > > toggle, but an absolute enable-or-disable command.
> > > > 
> > > > Not sure what you are trying to achieve here,
> > > > who triggers the SW_RADIO and why?
> > > 
> > > Thinkpad-acpi issues EV_SW SW_RADIO when the user changes a phisical
> > > switch in the unit.  It is a switch, not a button: it has an ON
> > > position, and an OFF position.
> > 
> > Ok, and such a switch is always intended to control all radios?
> > (in other words, it is the expected behavior it controls everything)
> 
> In every device I have seen which had a non-type-specific radio switch?
> Yes.
> 
> If we need type-specific switches (and NOT buttons/hot keys) for, e.g.,
> Bluetooth, the correct thing to do is to add EV_SW SW_BLUETOOTH.  The
> same goes for WWAN, UWB, etc.  But on laptops (which are the devices I
> am dealing with), these switches (when they exist) are meant to block
> *every* builtin radio and thus are not type-specific.
> 
> I can easily see someone designing a gadget with type-specific switches,
> but since nobody asked for such support yet, we don't have anything but
> SW_RADIO defined in the input layer right now.
> 
> So EV_SW SW_RADIO has "every radio" semanthics, just like KEY_RADIO.

Ok, thanks for the explanation.
You can add this patch to my ACK list then. :)

Ivo

