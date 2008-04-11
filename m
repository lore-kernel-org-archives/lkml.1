Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbYDKUxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbYDKUxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760017AbYDKUx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:53:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56214 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760234AbYDKUx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:53:29 -0400
X-Sasl-enc: glenmdwHJOuVyTi08LUlzNH4k/lYVDmMRxTFv37uBTeM 1207947208
Date: Fri, 11 Apr 2008 17:53:26 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6/8] rfkill: add the WWAN radio type
Message-ID: <20080411205326.GD14452@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-7-git-send-email-hmh@hmh.eng.br> <200804111344.09226.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804111344.09226.inaky@linux.intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008, Inaky Perez-Gonzalez wrote:
> On Friday 11 April 2008, Henrique de Moraes Holschuh wrote:
> > Unfortunately, instead of adding a generic Wireless WAN type, a technology-
> > specific type (WiMAX) was added.  That's useless for other WWAN devices,
> > such as EDGE, UMTS, X-RTT and other such radios.
> > 
> > Add a WWAN rfkill type for generic wireless WAN devices.  No keys are added
> > as most devices use KEY_RADIO for WWAN control and need no specific keycode
> > added.
> 
> I know it is easier to complain than to submit code, but at this
> point, shouldn't we make this dynamic? [so that the interested technology
> that provides an rfkill switch registers it?].

I wouldn't have anything against that, but we do need to coalesce the
types when possible, otherwise the "type" notion becomes useless for
rfkill-input.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
