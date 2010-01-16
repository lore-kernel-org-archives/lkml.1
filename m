Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab0APDDF (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199Ab0APDDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:03:03 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55659 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938Ab0APDDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:03:01 -0500
X-Sasl-enc: IKtD3W9LSxEo9kmfMz2KL+LPp0pyxFzT016DXdPKbNpD 1263610980
Date: Sat, 16 Jan 2010 01:02:57 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Seth Heasley <seth.heasley@intel.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel
 Cougar Point DeviceIDs
Message-ID: <20100116030257.GG3814@khazad-dum.debian.net>
References: <201001121700.18234.seth.heasley@intel.com>
 <4B4D4EAA.2010109@gmail.com>
 <4B4DAA68.60608@pobox.com>
 <51f3faa71001131611y343ad225n1acc73900fd49894@mail.gmail.com>
 <51f3faa71001131642u2cc9de80n8e73be7a8707afb2@mail.gmail.com>
 <20100114201136.GA3814@khazad-dum.debian.net>
 <51f3faa71001141615k3223a02fhb0b882b6cbe680cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f3faa71001141615k3223a02fhb0b882b6cbe680cf@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Robert Hancock wrote:
> > Maybe it is the silicon AHCI in ICH6R that is immature, and one is much
> > better of using it in IDE mode?
> 
> That seems unlikely, since the Intel-provided Matrix Storage drivers
> for that controller on Windows will be using AHCI mode..

That doesn't say much.

If the change doesn't risk switching unaware users from IDE mode to AHCI, it
is not a problem.  But if it does, why risk it?  It is not like anyone that
wants hotplug and has an ICH6-R/M system won't have figured it out by now
how to get it to use AHCI, these are NOT new systems.

AHCI in ICH6R or ICH6M is not always an advantage.  You don't want it on
ICH6-M in a laptop if it is not going to use the hotplug, for example.  In
AHCI mode, the chip draws more power.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
