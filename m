Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbYDRTi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbYDRTi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 15:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759765AbYDRTiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 15:38:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:50470 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYDRTip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 15:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=p3xa2ghmgfRgrSFrSjCUuznYtoOsqLE+LpwThj52VWX6gWay09pxwrz4oiy7bExOOAmk5hWidbmArnxsXb0CAzxP56i09PgZwZ3kukbob1QtJKs1JQ42jsGgZkN/WVHXXZHsoW+WJ+Qjq+Pk4+WMhhM3sOEu7f68qL7mi/K5AaI=
Date: Fri, 18 Apr 2008 23:38:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew <jackdachef@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25
Message-ID: <20080418193802.GK7674@cvg>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <alpine.LFD.1.00.0804180843150.2879@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804180843150.2879@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Linus Torvalds - Fri, Apr 18, 2008 at 08:43:35AM -0700]
| 
| 
| On Fri, 18 Apr 2008, Matthew wrote:
| > 
| > I can "reproduce" this on an Intel Core 2 Duo 6600 (Conroe) with a P5W
| > DH Deluxe mainboard (by Asus) since at least 2.6.25-rc8 (or possibly
| > also rc7)
| 
| Can you bisect it? 
| 
| 		Linus

it seems drivers/acpi/thermal.c has a small nit

881:	/* sys I/F for generic thermal sysfs support */
882:	#define KELVIN_TO_MILLICELSIUS(t) (t * 100 - 273200)

but it should multiply by 1000 meguess

		- Cyrill -
