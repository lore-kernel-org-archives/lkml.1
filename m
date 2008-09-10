Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYIJObV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYIJObV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYIJObA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:31:00 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:59866 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYIJObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XGRbZO5uVSv/3t9/uhDwvQegi66U0oW9xZGPVPDO9h62IhH7M81zW5Fwr/pX83FjZb
         fO5iV3ZyxqLFVq3RWfWnRhk+TiEcP5R1V/ysAwDe10OfDjKWW+ML5GBQlac+WgAQzbm/
         a/r3ekPjnCfy511gqWmxURspd5Z135w8waw5E=
Date: Wed, 10 Sep 2008 10:30:54 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jarod Wilson <jwilson@redhat.com>,
       Ville Syrj?l? <syrjala@sci.fi>, Janne Grunau <j@jannau.net>,
       linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>,
       lirc-list@lists.sourceforge.net
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Message-ID: <20080910143054.GA32156@anvil.corenet.prv>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-7-git-send-email-jwilson@redhat.com> <20080910095832.GA22422@sci.fi> <200809100905.58304.jwilson@redhat.com> <20080910131432.GA2161@infradead.org> <9e4733910809100637t55cdf1c0r19372bb74d3be57d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910809100637t55cdf1c0r19372bb74d3be57d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 09:37:19AM -0400, Jon Smirl wrote:
> A second issue is that some IR drivers are completely in user space.
> Is there a mechanism for these user space drivers to send events down
> into the input layer? These events would then get queued with the
> other kernel generated events and be delivered to consuming apps in
> order.
> 

Uinput driver (/dev/uinput, drivers/input/misc/uinput.c) can be used to
inject events into kernel for subsequent distribution through normal
interfaces (console, evdev, etc).

-- 
Dmitry
