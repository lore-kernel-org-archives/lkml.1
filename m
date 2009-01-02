Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZABKar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZABKar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbZABKah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:30:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:57454 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZABKag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:30:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rj+yznbOu9qn8RJ6A1fT9F178D9Gyttu4NcN4wicLXVXYOmNmJGBs7zwZxCWz6XsKL
         7uHbDoPJl5OnMhukbQQGjtdjHvABWyXARuk+NZQhcnQybxFhWIVFceIL7wIXs38oYkHd
         52/yx/a2F2XWP1T2gJQigvN4LGXOsNJTi0+/0=
Date: Fri, 2 Jan 2009 13:30:32 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 3/3] acpi: check for pxm_to_node_map overflow
Message-ID: <20090102103032.GB13629@localhost>
References: <20090102082717.810810508@gmail.com>> <495dd169.0437560a.1cd3.ffffd503@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495dd169.0437560a.1cd3.ffffd503@mx.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Fri, Jan 02, 2009 at 11:27:20AM +0300]
| It is hardly (if ever) possible but in case of broken _PXM
| entry we could reach out of pxm_to_node_map array
| bounds in acpi_map_pxm_to_node() call. Lets check it
| (it's not that expensive and safe).
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| CC: Len Brown <lenb@kernel.org>
...

Oops, I forgot to CC Andi, sorry.

		- Cyrill -
