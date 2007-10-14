Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbXJNDoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbXJNDoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 23:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbXJNDoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 23:44:06 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:56966 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbXJNDoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 23:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=I0RWgSS/KwMBMdoLYlorL7lh07JlqFQIbWKb/DQuFtCT/9C8BS1cVjey5t1q01QZGNscsav72/CKCTKmaf2qlwEKXqyBciEDMAcGwuV/tnFx96oml+EFSine/pHFY+vgKld35umsaNrNijCliefUe2v1d4qGl4vZA7aP0qn7KFU=
Message-ID: <47118FC0.6000307@googlemail.com>
Date: Sun, 14 Oct 2007 05:40:48 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: gregkh@suse.de, David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org
Subject: Re: [bug] usb build failure, latest -git
References: <20071014032948.GA25760@elte.hu>
In-Reply-To: <20071014032948.GA25760@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> FYI, the attached config fails to build on most recent -git with:
> 
>  In file included from drivers/usb/host/ohci-hcd.c:1038:
>  drivers/usb/host/ohci-ssb.c:120: error: 'ohci_bus_suspend' undeclared here (not in a function)
>  drivers/usb/host/ohci-ssb.c:121: error: 'ohci_bus_resume' undeclared here (not in a function)
>  make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1

Patch posted by Al Viro should fix that I think.
http://lkml.org/lkml/2007/10/13/221

Regards,

Gabriel
