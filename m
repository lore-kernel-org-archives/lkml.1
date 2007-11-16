Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbXKPQDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbXKPQDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXKPQDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:03:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57100 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbXKPQDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:03:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Franck Bui-Huu" <vagabon.xyz@gmail.com>
Subject: Re: apm emulation driver broken ?
Date: Fri, 16 Nov 2007 17:20:49 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com>
In-Reply-To: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161720.50313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, 16 of November 2007, Franck Bui-Huu wrote:
> Rafael,
> 
> Looking at commit:
> 
> 	831441862956fffa17b9801db37e6ea1650b0f69
> 	Freezer: make kernel threads nonfreezable by default
> 
> it seems that you broke the apm emulation driver.
> 
> You removed PF_NOFREEZE flag setting in apm_ioctl(), which is
> definitely not part of the apm kernel daemon but instead is called by
> user space proccesses...

Yes ...

> I'm just reading this code for the first time so I can be wrong but it
> looks like it's not going to work anymore.
> 
> Could you confirm ?

Well, no, AFAICS.

The freezer doesn't regard the current task as freezable.

Greetings,
Rafael
