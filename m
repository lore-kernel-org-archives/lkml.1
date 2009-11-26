Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZKZXOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZKZXOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 18:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZKZXOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 18:14:35 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57974 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZXOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 18:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qMfc8FUjJempXc3kerQMBpP7zjM1I1RnfYCs/8uLh0Xx0Ca0Le11GmNYd+uw5G3azq
         u3neRRK98kkp971CNKfOovRnFndADhNIHZWaNtYrXWSZ3fT3Uq/bWtAXS1fzbm91AstG
         N1nzYIlPWbK1X77I+yIDKdfs4NRk+JdYXhs/Y=
Date: Thu, 26 Nov 2009 15:14:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
       Mario Limonciello <superm1@ubuntu.com>, linux-input@vger.kernel.org,
       linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091126231436.GC6936@core.coreip.homeip.net>
References: <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain> <4B0E765C.2080806@redhat.com> <m3iqcxuotd.fsf@intrepid.localdomain> <4B0ED238.6060306@redhat.com> <m3pr75rpqa.fsf@intrepid.localdomain> <4B0EED7D.90204@redhat.com> <m3ljhtrn83.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3ljhtrn83.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 10:27:08PM +0100, Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> > No. All the other API functions there work with 32 bits for scancodes.
> 
> We don't need them, do we? We need a new ioctl for changing key mappings
> anyway (a single ioctl for setting the whole table I think), and we can
> have arbitrary length of scan codes there.

Unless we determine that we 100% need bigger size of scancode then the
current ioctls are just fine. Why do we _need_ an ioctl to load the whole
tabe? Are you concerned about speed with which the keymap is populated?
I don't think it would be an issue.

-- 
Dmitry
