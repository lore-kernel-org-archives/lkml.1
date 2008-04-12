Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbYDLMWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbYDLMWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761063AbYDLMW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:22:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:58865 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbYDLMW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=t5IiwjWKFFghE1osG6W5HfgXwkl0gg9sl27/C8U6VrbTyj/FMH9znisyKBpj7UV6Q6GHLUy0lNrlIFNyYSddPjQdQLFmEGvh84l5aYIoIWrL3cAyg1HQz+3neiM0DvAqJnYIIldwfzd2110uEpp1VZ26rZQYv3YmEFoWrKJozdc=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Date: Sat, 12 Apr 2008 14:23:59 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.41635.IvDoorn@gmail.com> <20080412120531.GA3402@khazad-dum.debian.net>
In-Reply-To: <20080412120531.GA3402@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121423.59988.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > On Friday 11 April 2008, Henrique de Moraes Holschuh wrote:
> > > The *_RADIO input events are related to all radios in a system.  There are
> > > two: KEY_RADIO and SW_RADIO.
> > > 
> > > Teach rfkill-input how to handle them.  In particular, SW_RADIO is not a
> > > toggle, but an absolute enable-or-disable command.
> > 
> > Not sure what you are trying to achieve here,
> > who triggers the SW_RADIO and why?
> 
> Thinkpad-acpi issues EV_SW SW_RADIO when the user changes a phisical
> switch in the unit.  It is a switch, not a button: it has an ON
> position, and an OFF position.

Ok, and such a switch is always intended to control all radios?
(in other words, it is the expected behavior it controls everything)

Ivo
