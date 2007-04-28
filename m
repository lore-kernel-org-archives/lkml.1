Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbXD1PO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbXD1PO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXD1PO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:14:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52005 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbXD1PO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:14:26 -0400
Message-ID: <463364CF.20801@garzik.org>
Date: Sat, 28 Apr 2007 11:14:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Greg KH <greg@kroah.com>
Subject: Re: [DOC] Fix wrong identifier name in Documentation/driver-model/devres.txt
References: <200704260926.33826.eike-kernel@sf-tec.de>
In-Reply-To: <200704260926.33826.eike-kernel@sf-tec.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rolf Eike Beer wrote:
> Above and below we talk about my_midlayer_create_something, I assume that is
> also meant here.
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> 
> ---
> commit bb5f6ef5bbbdc0233690fe3ba6d5787a6aab9b33
> tree cd948e03b4add89be6e648d31b7778c64a51e8d2
> parent 64aa7c3136258d3abc76354b5f83b9a9575169c0
> author Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 26 Apr 2007 09:23:39 +0200
> committer Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 26 Apr 2007 09:23:39 +0200
> 
>  Documentation/driver-model/devres.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> index 5163b85..6c8d8f2 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -182,7 +182,7 @@ For example, you can do something like the following.
>  
>  	...
>  
> -	devres_close_group(dev, my_midlayer_something);
> +	devres_close_group(dev, my_midlayer_create_something);
>  	return 0;

hmmm.

Now that devres is in the kernel, I don't think I am the best person to 
merge these sort of patches.  Certainly I can, and I know the code from 
my original review and subsequent usage, but I think the patch is more 
appropriate for Greg, going through normal maintainership channels.

IOW, I think devres is too generic to be queued via libata-dev.git.

Tejun, comments?

	Jeff


