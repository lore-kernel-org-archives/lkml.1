Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYHTBcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYHTBcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYHTBcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:32:25 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38435 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbYHTBcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:32:24 -0400
X-Sasl-enc: B6YLttBL4ccjUvsBZUHO40LwO6w5LRoGrfvuTu2C34H2 1219195942
Date: Tue, 19 Aug 2008 22:32:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, corentincj@iksaif.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] eeepc-laptop: Use standard interfaces
Message-ID: <20080820013214.GF29336@khazad-dum.debian.net>
References: <20080804170833.GA9513@srcf.ucam.org> <20080806092352.GA17801@srcf.ucam.org> <20080806092523.GB17801@srcf.ucam.org> <20080819025815.b5ec1a4c.akpm@linux-foundation.org> <20080819111320.GA19223@srcf.ucam.org> <20080819230950.GC29336@khazad-dum.debian.net> <20080819232411.GA5421@srcf.ucam.org> <20080820011828.GD29336@khazad-dum.debian.net> <20080820012846.GA7467@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820012846.GA7467@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew!

On Wed, 20 Aug 2008, Matthew Garrett wrote:

> On Tue, Aug 19, 2008 at 10:18:29PM -0300, Henrique de Moraes Holschuh wrote:
> 
> > 1. If the event has no bearing on compulsory hardware state changes (i.e.
> > the hardware won't change state by itself when the event happens, it is
> > really just reporting a simple key press that will do nothing by itself),
> > you just report the key as an event.
> 
> Yes. That's all I do.
> 
> > 2. If the hardware/firmware *ALSO* compulsory changes the rfkill state (i.e.
> > the event also means the real rfkill controller state probably changed), you
> > take the opportunity to do a forced immediate state poll and
> > rfkill_force_state() the new state.
> 
> The firmware does not perform any compulsory change.

Then, I have no futher comments.  Looks good to me.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
