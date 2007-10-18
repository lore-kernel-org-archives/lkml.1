Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbXJRA25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbXJRA25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759746AbXJRA2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:28:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60271 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759530AbXJRA2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:28:42 -0400
Message-ID: <4716A8B4.5060406@garzik.org>
Date: Wed, 17 Oct 2007 20:28:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Subject: Re: [PATCH] vortex_up should initialize "err"
References: <1192662956.14504.14.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1192662956.14504.14.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
> Simple compile warning fix. (against 2.6.23-git12)
> 
> Thanks,
> Badari
> 
> vortex_up() should initialize 'err' for a successful return.
> 
> drivers/net/3c59x.c: In function `vortex_up':
> drivers/net/3c59x.c:1494: warning: `err' might be used uninitialized in this function

applied as an obvious bug fix (Steffen added to CC)

