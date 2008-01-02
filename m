Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbYABBAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbYABBAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 20:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbYABBAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 20:00:40 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:2057 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756210AbYABBAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 20:00:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZPU1LmlhxkGeFEGGr3bONI1S4lpPRv8MF5YUPxo+xxM7CdjGZhursmq5aiS16cr2BEMVWxjngTCE+b6+16MUKLkh1mz2iA3FxfR8SoVj1nZ+0THWEfFrcNHCXa5Ur3NV6cUvn523HC+1np/jEXNL+x5ogsT0P1FkunOoKTUIHgY=
Message-ID: <a8e1da0801011700q72f63ce1wf2a224900b459b37@mail.gmail.com>
Date: Wed, 2 Jan 2008 09:00:39 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [BUG][PATCH] bluetooth: put_device before device_del fix
Cc: marcel@holtmann.org, akpm@linux-foundation.org, greg@kroah.com,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <20071229.191855.100656438.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071227052750.GA6296@darkstar.te-china.tietoenator.com>
	 <20071229.191855.100656438.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 11:18 AM, David Miller <davem@davemloft.net> wrote:
> From: Dave Young <hidave.darkstar@gmail.com>
> Date: Thu, 27 Dec 2007 13:27:50 +0800
>
> > Because of workqueue delay, the put_device could be called before device_del, so move it to del_conn.
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> Applied, thanks Dave.
>
> Please post bluetooth patches, just like any other networking patches,
> to netdev@vger.kernel.org (CC:'ing me) so that other networking
> developers can process them during times like these when most
> maintainers aren't around and thus not looking at bug fixes like
> your's.
>

Ok, thanks for pointing out, I didn't know this before.

Regards
dave
