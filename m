Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbZKZFxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbZKZFxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZKZFxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:53:03 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:48219 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZKZFxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:53:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IA3XJmcJORePZn8G83o/or8nZAsSDtQwgha8i+Caxk+NPfBkzErOU0sMlrFICe0QtF
         PNW8Iib23mQZ7qgJuxQmpbdx2kLGpzTU0ih/v6ifajv7sm4qtBb8xGPPhvKr0W4eBSTe
         t2ZOkp9XskqODrxpfcqOg0l8mbvzQeu+E/+/w=
Date: Wed, 25 Nov 2009 21:53:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jarod Wilson <jarod@wilsonet.com>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ?
Message-ID: <20091126055302.GI23244@core.coreip.homeip.net>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain> <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com> <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com> <E88E119C-BB86-4F01-8C2C-E514AC6BA5E2@wilsonet.com> <m3skc249ev.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3skc249ev.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 09:49:28PM +0100, Krzysztof Halasa wrote:
> Jarod Wilson <jarod@wilsonet.com> writes:
> 
> > Well, we've got a number of IOCTLs already, could extend those.
> > (Although its been suggested elsewhere that we replace the IOCTLs with
> > sysfs knobs).
> 
> Not sure if sysfs would be fast enough.
> 

Why would sysfs write be slower than ioctl?

-- 
Dmitry
