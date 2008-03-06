Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYCFKUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYCFKUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYCFKUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:20:30 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3084 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbYCFKUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:20:30 -0500
Date: Thu, 6 Mar 2008 10:20:26 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Make some text more consinstent and informative
Message-ID: <20080306102026.GB25123@shadowen.org>
References: <47CF0748.3060203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF0748.3060203@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 09:49:12PM +0100, Paolo Ciarrocchi wrote:
> Hi Andy,
> 
> Now messages about missing spaces or not needed spaces are in the format:
> 	space is required
> 	space is not required
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>

The current version (which your patch has crossed with) has these changed
to "required" and "prohibited" respectivly, to remove the ambiguity introduced by
tehe "no spaces X" form.

I did consider and reject the "is not required" form.  In english this
does not correct carry the "must not be present" meaning, it more means
"may or may not be present at your option".  Which is not what we are
trying to say either.

Hopefully the new wording is clearer to native and non-native english
speakers alike.

Thanks for doing the patch even so.

-apw
