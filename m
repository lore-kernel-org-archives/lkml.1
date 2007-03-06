Return-Path: <linux-kernel-owner+w=401wt.eu-S932927AbXCFBbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbXCFBbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXCFBbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:31:45 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:8356 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbXCFBbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:31:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ez+b96cl2SrpAE066NMbbJfPkRKVONEI6GCEeJsP/t1CF7MqEo0cDPQ9PGuXpMC5zYc54xBT8yr/nGW6bxl/zIV3o6QjKs1gz9GXZbIbC0Vvm+EmyCtXSy79fd//tMg9BMp7yLjZgcREiyJfYe8BOewS3Ry45/pH4HFAI7nbHaE=
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: DervishD <lkml@dervishd.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
In-Reply-To: <20070301160139.GA102@DervishD>
References: <20070226144744.GA3615@DervishD>
	 <1172503471.20842.14.camel@daplas> <20070226171334.GB13496@DervishD>
	 <1172510654.7101.11.camel@daplas> <20070226203223.GA161@DervishD>
	 <1172617755.13422.0.camel@daplas>  <20070301160139.GA102@DervishD>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 09:33:37 +0800
Message-Id: <1173144817.7219.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 17:01 +0100, DervishD wrote:
>     Hi Antonino :)
> 
>  * Antonino A. Daplas <adaplas@gmail.com> dixit:
> > Can you try this patch?  It might help with the screen corruption.
> 
>     With the patch, the scroll slows to a crawl and the system is
> unusable. The time to scroll 30 lines is about a minute or so (probably
> more, I just measured for a while).
> 
>     If you want me to test other patches, just tell :)

Can you change the mdelay to udelay and use higher/lower delay values to
see if there's any improvement?

Tony


