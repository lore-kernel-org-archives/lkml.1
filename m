Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYIVC0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYIVC0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 22:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYIVCZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 22:25:58 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:19824 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYIVCZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 22:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q7O1Lcb2RtYubgx42UuaKnN4efisBWvjhdc7BncM3Wxi9LZHL2SA2L5nJNNsgUejQb
         yH+lQS9wcHg+3qwm1uCNIM7BEaYKkDV4xopOM6af+ymy0PpC4msFSyBSB+Q3oizX0SNW
         WqXJJEk3KzUtQioJlfdpouZE+PEyLOiN3CvwI=
Date: Mon, 22 Sep 2008 11:25:43 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] acer-wmi: add error checks in module_init
Message-ID: <20080922022529.GA3009@localhost.localdomain>
References: <200809211853.19889.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809211853.19889.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 06:53:19PM +0100, Carlos Corbacho wrote:
> On Sunday 21 September 2008 15:29:59 Akinobu Mita wrote:
> > This patch fixes these bugs by using platform_device_register_simple()
> 
> [Adding Greg KH to CC - 2nd time lucky...]
> 
> Last I heard, platform_device_register_simple() was in the process of being 
> deprecated and then slated for future removal. Has this changed?

I didn't know about that plan. But if platform_device_alloc/add is
more preferable API than platform_device_register_simple().
I'll amend those patches and resend them.
