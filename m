Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbYDLMF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbYDLMF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbYDLMFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:05:47 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46261 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758035AbYDLMFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:05:46 -0400
X-Sasl-enc: KmOXG4lJf84IQ7SLxGDFufDyNvjiN3QYmSbiEKAsg4fB 1208001944
Date: Sat, 12 Apr 2008 09:05:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Message-ID: <20080412120531.GA3402@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-4-git-send-email-hmh@hmh.eng.br> <200804121236.41635.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804121236.41635.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> On Friday 11 April 2008, Henrique de Moraes Holschuh wrote:
> > The *_RADIO input events are related to all radios in a system.  There are
> > two: KEY_RADIO and SW_RADIO.
> > 
> > Teach rfkill-input how to handle them.  In particular, SW_RADIO is not a
> > toggle, but an absolute enable-or-disable command.
> 
> Not sure what you are trying to achieve here,
> who triggers the SW_RADIO and why?

Thinkpad-acpi issues EV_SW SW_RADIO when the user changes a phisical
switch in the unit.  It is a switch, not a button: it has an ON
position, and an OFF position.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
