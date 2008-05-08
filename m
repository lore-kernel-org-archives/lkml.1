Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbYEHVGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbYEHVGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761115AbYEHVFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:05:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:13242 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755AbYEHVFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=H43VjqzlOhgqzGOEuTA65H1w/22YReIz2FCdQWKhj07qRj2YORKgu1s2kJNvzIjA4Tl1lCwNM7o0+2+TY7B/mh61iy8aiDCf1rTudE4gSacFcGYN6LAitCL29UrQB/RDW9jKgiF7YSkv1E/MjwAiapmfZWJgWvN5wsHeLAJ9XNA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 4/6] ide: remove IDE_TFLAG_NO_SELECT_MASK taskfile flag
Date: Thu, 8 May 2008 23:22:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <200805071943.24296.bzolnier@gmail.com> <20080508205802.GA5722@flint.arm.linux.org.uk>
In-Reply-To: <20080508205802.GA5722@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805082322.13297.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2008, Russell King wrote:
> On Wed, May 07, 2008 at 07:43:24PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Always call SELECT_MASK(..., 0) in ide_tf_load() (needs to be done
> > to match ide_set_irq(..., 1)) and then remove IDE_TFLAG_NO_SELECT_MASK
> > taskfile flag.
> > 
> > This change should only affect hpt366 and icside host drivers since
> > ->maskproc(..., 0) for sgiioc4 is equivalent to ide_set_irq(..., 1).
> 
> Provided the two channels on icside are serialised (so IDE doesn't
> try to enable IRQs on both channels at the same time) it shouldn't
> be a problem.

Yep, they are serialized.

> However, since I don't use this driver anymore (using the PATA version
> instead) I don't feel it's right for me to ack this change.

Thanks for taking a look anyway.

Bart
