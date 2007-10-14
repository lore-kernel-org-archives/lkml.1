Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXJNJdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXJNJdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 05:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXJNJdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 05:33:37 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58399
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbXJNJdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 05:33:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug] usb build failure, latest -git
Date: Sun, 14 Oct 2007 11:32:46 +0200
User-Agent: KMail/1.9.6
Cc: gregkh@suse.de, David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
References: <20071014032948.GA25760@elte.hu>
In-Reply-To: <20071014032948.GA25760@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710141132.46517.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007 05:29:48 Ingo Molnar wrote:
> 
> FYI, the attached config fails to build on most recent -git with:
> 
>  In file included from drivers/usb/host/ohci-hcd.c:1038:
>  drivers/usb/host/ohci-ssb.c:120: error: 'ohci_bus_suspend' undeclared here (not in a function)
>  drivers/usb/host/ohci-ssb.c:121: error: 'ohci_bus_resume' undeclared here (not in a function)
>  make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> 
> found via randconfig testing.
> 
> 	Ingo
> 

A patch is already submitted, thanks.

-- 
Greetings Michael.
