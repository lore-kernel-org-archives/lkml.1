Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbYAJKEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbYAJKEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759312AbYAJKEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:04:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33498 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279AbYAJKEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:04:22 -0500
Date: Thu, 10 Jan 2008 11:06:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, paolo.ciarrocchi@gmail.com,
       gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080110100657.GB25292@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <200801100952.55039.eike-kernel@sf-tec.de> <20080110092528.GA25076@one.firstfloor.org> <200801101102.16971.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801101102.16971.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So if I write my own driver and have never heard of ioctls running on BKL 
> before I can rather be sure that I just can change the interface of the ioctl 
> function, put it in unlocked_ioctl and are fine? Cool.

If you know the BKL is not needed in your code you should use unlocked_ioctl
correct.

-Andi
