Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYIRNSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYIRNSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYIRNSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:18:30 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49964 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbYIRNSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:18:30 -0400
X-Sasl-enc: LlrTfXlS4ZDYPyZ45EKrqyoChNEuW3yqAaUnJCiCNalk 1221743908
Date: Thu, 18 Sep 2008 10:18:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Michael Buesch <mb@bu3sch.de>, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rfkill: update LEDs for all state changes
Message-ID: <20080918131824.GD1583@khazad-dum.debian.net>
References: <20080917023334.GA1187@khazad-dum.debian.net> <1221682077-21170-1-git-send-email-hmh@hmh.eng.br> <48D16EDB.8090700@lwfinger.net> <20080918124318.GB1583@khazad-dum.debian.net> <48D25311.1010805@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D25311.1010805@lwfinger.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008, Larry Finger wrote:
> Henrique de Moraes Holschuh wrote:
> > Curious.  My patch to rfkill WAS tested, and it DOES fix the same issue you
> > reported (hardware state changes to HARD_BLOCKED do not update the LEDs) in
> > thinkpad-acpi.  It is also an "obviously correct" patch.
> > 
> > What this probably means is that b43 would need a little more rfkill surgery
> > than what Matthew's patch already did.  I will look over Matthew's patch,
> > but my guess is that Michael's comments about the need to add some extra
> > code to b43 to actually synthesize the rfkill state from the separate HW and
> > SW rfkill input lines are a strong hint of where the problem might be.
> 
> You must have missed my mail that shows the corrected patch for b43.
> See http://marc.info/?l=linux-wireless&m=122171448920267&w=2.

Indeed I have.  I will read it now and comment on it.

Thanks for the heads' up :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
