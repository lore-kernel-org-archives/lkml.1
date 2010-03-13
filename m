Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab0CMOmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 09:42:40 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:59716 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205Ab0CMOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 09:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bWTPpw4eFZ9iRmgbR2hzNFn2S+x0A+LhoOKllZii9C75F+na8FwD8pdYYA8oOloPAe
         TXPllDNu4wFk3GBC0jaRtLwUK4CHJdBUwU4Yg26vJNTbGERssn5/D2DnLcLs5oEWwNW4
         naYS/zEX3TgsB1BfTV94A68j8xFSkXSacqK1M=
Date: Sat, 13 Mar 2010 17:40:21 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       diegoliz@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mds.c whitspace, indentation etc.
Message-ID: <20100313144021.GA19207@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
	penberg@cs.helsinki.fi, pavel@ucw.cz, diegoliz@gmail.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1268489199-5356-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268489199-5356-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thanks for the patch.  I verified that the compiled version
was the same before and after.  It cleans up the code a lot.

> +		} else { /*DSSS*/
> +			/*CTS duration
> +			 *2 SIFS + DATA transmit time + 1 ACK
> +			 * Rate : ?? Mega bps
> +			 *ACK frame length = 14 bytes
> +			 */

There are a couple places like this.  Could you put spaces between the
'*' and the first character?  In fact those two comments could be combined
probably.

Once you fix that, check everything again and resend.  Looks good.

regards,
dan carpenter
