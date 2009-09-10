Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZIJKjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZIJKjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZIJKjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:39:45 -0400
Received: from mail.sdinet.de ([78.47.32.153]:38826 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbZIJKjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:39:45 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2009 06:39:45 EDT
Date: Thu, 10 Sep 2009 12:29:33 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: disable : Ctrl -C in the Kernel
In-Reply-To: <241b8f7b0909100310t267b82cq976929d2f7b7734@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0909101228170.9074@aurora.sdinet.de>
References: <241b8f7b0909100310t267b82cq976929d2f7b7734@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009, Prabhu Chawandi wrote:

>   I am running Some application at the end of rcS script file.
> 
> I need to disable Ctrl-c, i.e.  application should not kill after Ctrl-c.
> 
> and in some case I want Ctrl-C to work normally.
> 
> I am taking care in application about catching signal using signal(),
> even then I think there is something from kernel side.
> 
> Can any one help ?????/

We are using the following command here in an rc script early at boot to 
disable Ctrl-C:

	stty intr ^@ quit ^@ susp ^@

c'ya
sven

-- 
The lights are fading out, once more...
