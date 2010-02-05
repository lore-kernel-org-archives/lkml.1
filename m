Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab0BECwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 21:52:40 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:34488 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab0BECwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 21:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=date:from:to:cc
	:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=jTxCaj
	2e7R2lb+KwlPpERFoQ0qe5BES8x0i96XNWNTQtv8aGfy04TqV9wkCFtdKbCHsGax
	RSX2wc/g4XqWVU0jzWUT4/u4Mtc4CY2FVNb9BF7kzWPzWgQXeTi602wOZJbITkhq
	ZiPR5XL9mb7XHYq4b5veYCSmRi8MuDzRXmnu8=
Date: Thu, 4 Feb 2010 20:52:27 -0600
From: Corey Wright <undefined@pobox.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: regression in 2.6.27.45 with usb and suspend-to-disk
Message-Id: <20100204205227.b8a3fa14.undefined@pobox.com>
In-Reply-To: <Pine.LNX.4.44L0.1002041407151.1261-100000@iolanthe.rowland.org>
References: <20100204014653.1ed6b9e3.undefined@pobox.com>
 <Pine.LNX.4.44L0.1002041407151.1261-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 81A41044-1201-11DF-9A68-6AF7ED7EF46B-06295150!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 14:15:09 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Below is a slightly improved version of the patch.  It's what I intend 
> to submit for 2.6.27.stable.  I'd appreciate your testing it to make 
> sure that it behaves properly on both machines.

rebuilt 2.6.27.45 with only your previously posted patch applied on both
the x86-64 desktop and i386 netbook and both computers suspended to disk
successfully three times in a row (when i stopped and declared success).

> Be sure to set CONFIG_USB_DEBUG in the netbook's kernel too.  If the 
> reason for its failure turns out to be different, we'll need the extra 
> information.

i set CONFIG_USB_DEBUG but thankfully didn't need it.

again, thanks for your work!

corey
-- 
undefined@pobox.com
