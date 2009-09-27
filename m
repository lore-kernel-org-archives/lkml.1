Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZI0KzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZI0KzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 06:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZI0Ky7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 06:54:59 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:38628 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbZI0Ky6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 06:54:58 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Sep 2009 06:54:58 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] lib/vsprintf.c: Add %pU - ptr to a UUID/GUID
Date: Sun, 27 Sep 2009 12:45:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Greg KH <greg@kroah.com>
References: <cover.1254030722.git.joe@perches.com> <1507728e0ea3deafa71c481d508a6e9765c92221.1254030722.git.joe@perches.com>
In-Reply-To: <1507728e0ea3deafa71c481d508a6e9765c92221.1254030722.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909271245.34000.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sunday 27 September 2009, Joe Perches wrote:
> UUID/GUIDs are somewhat common in kernel source.
> 
> Standardize the printed style of UUID/GUIDs by using
> another extension to %p.
> 
> %pU:    01020304:0506:0708:090a:0b0c0d0e0f10
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ here
> %pUr:   04030201:0605:0807:0a09:0b0c0d0e0f10
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ and here

Code does "01020304-0506-0708-090a-0b0c0d0e0f10".
This is not, what commit promises. Please change the commit message!

Best Regards

Ingo Oeser
