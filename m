Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab0BCOkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:40:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:36198 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003Ab0BCOki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:40:38 -0500
Date: Wed, 3 Feb 2010 15:40:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Bastien Nocera <hadess@hadess.net>, Michael Poole <mdpoole@troilus.org>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 2/3] HID: Implement Wacom quirk in the kernel
In-Reply-To: <1265206741.31341.114.camel@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1002031540221.15395@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>  <1264783166.29532.5302.camel@localhost.localdomain>  <87iqakifm8.fsf@troilus.org>  <1264860663.29532.7887.camel@localhost.localdomain>  <87bpg7glf7.fsf@troilus.org>  <1265190440.32444.8417.camel@localhost.localdomain>
  <alpine.LNX.2.00.1002031202040.15395@pobox.suse.cz>  <alpine.LNX.2.00.1002031343500.15395@pobox.suse.cz>  <alpine.LNX.2.00.1002031349230.15395@pobox.suse.cz> <1265206741.31341.114.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Marcel Holtmann wrote:

> Hi Jiri,
> 
> > The hid-wacom driver required user-space to poke at the tablet
> > to make it send data about the cursor location.
> > 
> > This patch makes it do the same thing but in the kernel.
> > 
> > Signed-off-by: Bastien Nocera <hadess@hadess.net>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Acked-by: Marcel Holtmann <marcel@holtmann.org>
> 
> >  
> > +	/* Set Wacom mode2 */
> > +	rep_data[0] = 0x03; rep_data[1] = 0x00;
> > +	limit =3;
> 
> Small nitpick here. The space after = is missing ;)

Fixed and applied. Thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
