Return-Path: <linux-kernel-owner+w=401wt.eu-S933886AbXHYJB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbXHYJB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933141AbXHYJBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:01:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:43548 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941AbXHYJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=j67lPyGR+XfoD2IPqey4QQ2fZGvurs/uVGawBZHQKO0R7uoN6pNwp554QfJtT64Iopdc7dLjDpkdK8wOw7qg+u0gkG5pQP/Kb2xIb83KlNIU+xZfNo4vZFI6dFGPAK/+WxS1lAeKzaG2wDUXdyALf6aU/NOgyt13NB+HBW/A6Bo=
Message-ID: <46CFF034.1030403@gmail.com>
Date: Sat, 25 Aug 2007 11:02:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: readXs on pci*iomap-ped regions [Was: [PATCH] /drivers/char sx.c
 ioremap -> pci_ioremap api]
References: <46CF2849.2090008@gmail.com> <4af2d03a0708241159v56b46299h46df9777a98590e5@mail.gmail.com> <20070824201530.5d741b37@the-village.bc.nu>	<46CF399E.3010808@gmail.com> <20070824213439.0007e653@the-village.bc.nu> <46CFEC40.7060006@gmail.com> <46CFEEB3.6000802@pobox.com>
In-Reply-To: <46CFEEB3.6000802@pobox.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik napsal(a):
> If the driver knows its MMIO, using readX/writeX after pci_iomap() is
> just fine, for all current implementations, and it makes sense that way.

Hmm, that's what I'm claiming.

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
