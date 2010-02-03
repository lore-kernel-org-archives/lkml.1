Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab0BCOUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:20:48 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36389 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab0BCOUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:20:45 -0500
Subject: Re: [PATCH 2/3] HID: Implement Wacom quirk in the kernel
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Bastien Nocera <hadess@hadess.net>, Michael Poole <mdpoole@troilus.org>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1002031349230.15395@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	 <1264783166.29532.5302.camel@localhost.localdomain>
	 <87iqakifm8.fsf@troilus.org>
	 <1264860663.29532.7887.camel@localhost.localdomain>
	 <87bpg7glf7.fsf@troilus.org>
	 <1265190440.32444.8417.camel@localhost.localdomain>
	 <alpine.LNX.2.00.1002031202040.15395@pobox.suse.cz>
	 <alpine.LNX.2.00.1002031343500.15395@pobox.suse.cz>
	 <alpine.LNX.2.00.1002031349230.15395@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 06:19:01 -0800
Message-ID: <1265206741.31341.114.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> The hid-wacom driver required user-space to poke at the tablet
> to make it send data about the cursor location.
> 
> This patch makes it do the same thing but in the kernel.
> 
> Signed-off-by: Bastien Nocera <hadess@hadess.net>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

>  
> +	/* Set Wacom mode2 */
> +	rep_data[0] = 0x03; rep_data[1] = 0x00;
> +	limit =3;

Small nitpick here. The space after = is missing ;)

Regards

Marcel


