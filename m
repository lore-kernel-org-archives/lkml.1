Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZHCXyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZHCXyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 19:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZHCXye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 19:54:34 -0400
Received: from senator.holtmann.net ([87.106.208.187]:60770 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZHCXyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 19:54:33 -0400
Subject: Re: [PATCH]bluetooth: rfcomm_init bug fix
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: hidave.darkstar@gmail.com, oliver@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090803.132924.151782729.davem@davemloft.net>
References: <20090803142616.GA1973@darkstar>
	 <20090803.132924.151782729.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 16:54:26 -0700
Message-Id: <1249343666.3094.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > rfcomm tty may be used before rfcomm_tty_driver initilized,
> > The problem is that now socket layer init before tty layer, if userspace
> > program do socket callback right here then oops will happen.
> > 
> > reporting in:
> > http://marc.info/?l=linux-bluetooth&m=124404919324542&w=2
>  ...
> > Reported-by: Oliver Hartkopp <oliver@hartkopp.net>
> > Tested-by: Oliver Hartkopp <oliver@hartkopp.net>
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> 
> Applied, thanks.

do you mind at least waiting for an ACK from my side. I haven't even
looked at the final patch.

Regards

Marcel


