Return-Path: <linux-kernel-owner+w=401wt.eu-S935865AbXJQVAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935865AbXJQVAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbXJQVAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:00:30 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:60456 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758859AbXJQVA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:00:29 -0400
Date: Wed, 17 Oct 2007 23:00:27 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Scott Wood <scottwood@freescale.com>, Carsten Juttner <carjay@gmx.net>,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       linuxppc-embedded@ozlabs.org
Subject: Re: [i2c] [PATCH take2] [POWERPC] i2c: adds support for i2c bus on
  8xx
Message-ID: <20071017230027.334a5f48@hyperion.delvare>
In-Reply-To: <47166085.1010608@scram.de>
References: <47134A94.60606@scram.de>
	<20071015183107.GA4361@loki.buserror.net>
	<47166085.1010608@scram.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 21:20:37 +0200, Jochen Friedrich wrote:
> >> +	/* Select an arbitrary address.  Just make sure it is unique.
> >> +	 */
> >> +	out_8(&i2c->i2c_i2add, 0xfe);
> >>     
> >
> > It's a 7-bit address...  and are you sure that 0x7e is unique?  Does this
> > driver even support slave operation?
> >   
> 
> It's in fact 0x7F << 1. The same value is used in the 2.4 driver and
> in u-boot, as well. Slave operation is not supported.

I'm not sure what exactly you are doing here, but 0x7f isn't a valid
7-bit I2C address.

-- 
Jean Delvare
