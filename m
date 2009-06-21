Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbZFUWhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbZFUWhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 18:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZFUWg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 18:36:58 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:40002
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752707AbZFUWg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 18:36:58 -0400
Date: Sun, 21 Jun 2009 18:36:58 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Frans Pop <elendil@planet.nl>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       David Gibson <david@gibson.dropbear.id.au>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Badness on the Warp
Message-ID: <20090621183658.2b408e69@lappy.seanm.ca>
In-Reply-To: <1245623104.16880.26.camel@pasglop>
References: <20090620154824.72b5cd50@lappy.seanm.ca>
	<200906202256.46073.elendil@planet.nl>
	<20090620194250.5a3e826f@lappy.seanm.ca>
	<200906210628.35553.elendil@planet.nl>
	<84144f020906210320n2984807dw2d4b4fb38afd22cf@mail.gmail.com>
	<1245623104.16880.26.camel@pasglop>
Organization: PIKA
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEXOy8P+/f8hHBFoOhetjm76/P5qPzJLJxltXUSaX0wbgtjEAAACY0lEQVQ4jWWUQWvcMBCF91BCjiuIIWcX6nsE9uZWgknjWwW7sD2rjL1XGzzpNS2ufI5xVv+2byTHSehcbO8nzWjeG+1GqcPhZfTlEl8/hUdVbgDUvfNT+SEqH8Ho/UdQCjDJg0dMceVUhVcBKhn8Go7qTjd4CYCcBL7OQ9GmGXfNuICauaNmIKrbNGWivAngQPhMOScibODGOZ2PYUfdMlCnyTJWpFlu9SkW14Ps6cdZHoJ4F4ENPzxOD3i2cZMA9VCHdV/KCmdC3i7WMAKyNuNfZVUwzoA2pmqjDkZd1ikjfpblTDj32PhSwEH9GHTBrQDvpaXT9Aqc1cz9HwHedg20qkLxK2cLNIh1q8p+Ae53TsMJ36shAewdDPHz+B/YDqOffEhTvXMQYIbp0SppIdQKIIG31XwK4Pk2OrYAuGQX0JHUowDUPY1O77xkeob6CLsxYQfZvMhxNJhYsNY56bjjktA6Pgl6WIiLiOC6g1hQltMMIJBY/FrEhcRisIWcrG3csa8DEOt6pGs5HwIw2zrkCW6TCN0sQP2tuwjSmouWb10EiXrJcUwhqAzfx2aWaYe5F48k9qbBYplKFybRmGPvbuJIyUTKTAagkquabrJWcnV0OqONqFWSfH/qi52cDOvHs10bVOobgEb73NPoh1WSJDky72whkmDcVmCkCMuJU9Yn/y6VMWaGriTTiesmUxZTIS4yOIR5qPzZSbMr2LefcaB4P/V7kNxlvcY9xJnEQ70Cc2w7aCFXtBCnVqC2uCEiU2hz6TxuuUsz0TDy/C1Vcgwayh8AwFvxg9k/LTcWUfA/se5dIXIv87sAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 08:25:04 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> Right, our interrupt controllers need those fixes, they are low
> on my priority list since it's a reasonably harmless warning and I'm
> still chasing some actual breakage (though maybe not directly related
> to your patches).
> 
> Kumar already submitted a couple, Frans, feel free to beat me
> at converting UIC (just use kmalloc directly in there instead
> of alloc_bootmem).

I can make the changes to UIC if you want. They badness is harmless (it
ends up calling kzalloc anyway), but hard to explain to our PV (Product
Verification) department that they can ignore what looks like a crash ;)

Cheers,
   Sean
