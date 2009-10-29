Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZJ2N6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZJ2N6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZJ2N6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:58:42 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48472 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbZJ2N6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:58:41 -0400
Subject: Re: [PATCH] firmware_class: make request_firmware_nowait more
 useful
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <gregkh@suse.de>, linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Pavel Roskin <proski@gnu.org>, Abhay Salunke <abhay_salunke@dell.com>
In-Reply-To: <1256816162.3865.110.camel@johannes.local>
References: <1256816162.3865.110.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 29 Oct 2009 22:58:12 +0900
Message-Id: <1256824692.5768.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> Unfortunately, one cannot hold on to the struct firmware
> that request_firmware_nowait() hands off, which is needed
> in some cases. Allow this by requiring the callback to
> free it (via release_firmware).
> 
> Additionally, give it a gfp_t parameter -- all the current
> users call it from a GFP_KERNEL context so the GFP_ATOMIC
> isn't necessary. This also marks an API break which is
> useful in a sense, although that is obviously not the
> primary purpose of this change.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I had a look at this one and looks good to me and makes perfect sense.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


