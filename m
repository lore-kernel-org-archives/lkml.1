Return-Path: <linux-kernel-owner+w=401wt.eu-S1751254AbXBMLRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbXBMLRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXBMLRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:17:37 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34971 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbXBMLRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:17:36 -0500
Date: Tue, 13 Feb 2007 12:15:57 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Laurent Pinchart <laurent.pinchart@technotrade.biz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: git issues while fetching from
 http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
Message-ID: <20070213121557.6a7442a8@frecb000686.frec.bull.fr>
In-Reply-To: <200702131030.00046.laurent.pinchart@technotrade.biz>
References: <200702131030.00046.laurent.pinchart@technotrade.biz>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/02/2007 12:18:50,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/02/2007 12:18:51,
	Serialize complete at 13/02/2007 12:18:51
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Laurent,


On Tue, 13 Feb 2007 10:29:59 +0100 Laurent Pinchart <laurent.pinchart@technotrade.biz> wrote:

> Hi everybody,
> 
> I'm trying to fetch from the Linux kernel repository at 
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/. After 
> downloading the objects, git failed while trying to fetch tags. Retrying the 
> fetch operation gives the following output:
> 
> $ git-fetch origin
> Fetching refs/heads/master from 
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/ using 
> http
> Auto-following refs/tags/v2.6.20
> Auto-following refs/tags/v2.6.20
> Auto-following refs/tags/v2.6.20-rc1
> Auto-following refs/tags/v2.6.20-rc1
> Auto-following refs/tags/v2.6.20-rc2
> Auto-following refs/tags/v2.6.20-rc2
> Auto-following refs/tags/v2.6.20-rc3
> Auto-following refs/tags/v2.6.20-rc3
> Auto-following refs/tags/v2.6.20-rc4
> Auto-following refs/tags/v2.6.20-rc4
> Auto-following refs/tags/v2.6.20-rc5
> Auto-following refs/tags/v2.6.20-rc5
> Auto-following refs/tags/v2.6.20-rc6
> Auto-following refs/tags/v2.6.20-rc6
> Auto-following refs/tags/v2.6.20-rc7
> Auto-following refs/tags/v2.6.20-rc7
> Failed to fetch refs/tags/v2.6.20 from 
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
> 
> While trying to solve the issue, I noticed that the refs/tags directory in the 
> remote repository is empty. Is that a normal situation ? Should git be able 
> to regenerate the tags locally from the objects ? I'm using git 1.4.4.4.

  I had the same issue. Upgrade git. the refs are now packed
in a single file packed-refs.

  Sébastien.
