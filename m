Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbYHFCdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbYHFCdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 22:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbYHFCc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 22:32:56 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54961 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961AbYHFCcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 22:32:54 -0400
X-Sasl-enc: 6WLpEFCVvEgIGH9dbW79pNrp0/vt7boUwZc28ofPBGoM 1217989973
Date: Tue, 5 Aug 2008 23:32:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Yves-Alexis Perez <corsac@debian.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Add Intel ACPI IGD OpRegion support
Message-ID: <20080806023247.GA4665@khazad-dum.debian.net>
References: <20080805183725.GA4468@srcf.ucam.org> <1217965470.5449.4.camel@hidalgo> <1217972874.4540.3.camel@hidalgo> <20080806001301.GA10630@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806001301.GA10630@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008, Matthew Garrett wrote:
> On Tue, Aug 05, 2008 at 11:47:54PM +0200, Yves-Alexis Perez wrote:
> > In booted into X (with hal, powersaved, dbus etc. running), and then,
> > tada, brightness keys work. There is a 750ms (I guess) delay, and I
> > don't know who is really responsible, I guess X is. (and thus I guess
> > the opregion is the one needed, and X manages the brightness. If the
> > kernel was, it would be working even in single user)
> 
> The 750ms delay is from thinkpad-acpi. I sent a patch to Henrique which 
> makes it go away, but I'm not entirely sure what the ACPI method 
> concerned is supposed to be doing. The opregion code won't currently run 
> until X is started because the drm layer requires X to be the foreground 
> vt before handling IRQs.

Well, for what is it worth, thinkpad-acpi has a knob (brightness_mode) which
can be used.  Set it to CMOS mode (see docs).  From what I recall, it should
do what your patch does.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
