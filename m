Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbXJQTfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbXJQTfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759241AbXJQTfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:35:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:41130 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635AbXJQTfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TNGfS3glsUiVXImmfPoxX7vwGJHbHgcn3EVS32sJPdrqVbYby4dLoHv9RO5v60obqFEr+tpIuQiDbxoVQgAYClBzQyUftyzR9AIELPKwHj2tZPMhO89Sw79jhAEISnMCu49CiUoqUkvjGrXPTSBaUGgKBdU9ll+LWpkn3elbFpI=
Message-ID: <471663EE.6090602@gmail.com>
Date: Wed, 17 Oct 2007 21:35:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Nick Thompson <Nick.Thompson@comtrol.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: RocketPort Linux driver errors on module reload
References: <B1F576FE19C55C43B8D2E31F061B50C062C3EE@exchange.comtrol.com>
In-Reply-To: <B1F576FE19C55C43B8D2E31F061B50C062C3EE@exchange.comtrol.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2007 07:06 PM, Nick Thompson wrote:
> I've been wanting to get the driver that is included in the kernel up to date, and there is an active project here at comtrol to get the current code (driver version 3.08 beta) up to Linux kernel programming standards. The driver version that is included in the kernel (and has been patched a bit I'm sure since it's been in there a while) is version 2.09. The latest version (3.08 beta) can be obtained from: 

the easiest way is to get diff -u 2.09 3.08 and port it by hand, at least I
ususally do it this way.

> ftp://ftp.comtrol.com/beta/rport/drivers/u_pci/linux/rocketport-linux-3.08.tar.gz
> 
> If anyone has any helpful pointers (no pun intended) or comments on the code, I'd love to listen. 

Convert to pci probing and in-kernel firmware loading :). The code is big mess
due to ifdefs and much unneeded material, it's likely impossible to say this is
wrong and this not, if you won't post a patch, where people will see the changes
you want to make. Then you will have feedback :).

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
