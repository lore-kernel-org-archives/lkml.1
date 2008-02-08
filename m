Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbYBHBEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbYBHBEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYBHBEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:04:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:35290 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbYBHBEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:04:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Yt4lyBs/8q8tEGLmbItKYbPIRd7/irXa3b9BIcVVXM4hwJTkxiDfwikevvzV9Xz/pHaDOaAx8nKeS1z1nRiRKx3msvGSWog1BIzHz8SbVs0ZKMre1puA4w0HLvh0UoyDAzilyPOoG2JxW5UbG2ajG3ry3LeKjWZUhwsLdETJvik=
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1202432206.3171.53.camel@localhost.localdomain>
References: <1202432206.3171.53.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 17:04:02 -0800
Message-Id: <1202432647.31361.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-07 at 18:56 -0600, James Bottomley wrote:
> Quite a bit of this is fixing things broken previously (the advansys fix
> is still pending resolution, but I'll send it as an -rc fix when we have
> it).  There's the final elimination of all drivers that are esp based
> but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> the usual bunch of driver updates and the addition of a new enclosure
> services driver and the corresponding ULD.
> 
> The patch is available from:
> 

I'm going to guess that this is the entry in feature-removal.txt
that need an update then:

---------------------------

What:	old NCR53C9x driver
When:	October 2007
Why:	Replaced by the much better esp_scsi driver.  Actual low-level
	driver can be ported over almost trivially.
Who:	David Miller <davem@davemloft.net>
	Christoph Hellwig <hch@lst.de>


Cheers,

Harvey

