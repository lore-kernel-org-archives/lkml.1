Return-Path: <linux-kernel-owner+w=401wt.eu-S1763528AbXHWM2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763528AbXHWM2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760866AbXHWM2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:28:22 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:57242 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760861AbXHWM2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:28:21 -0400
Date: Wed, 22 Aug 2007 23:35:07 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@osdl.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH 1/6] mips: irix_getcontext will always fail EFAULT
Message-ID: <20070822223507.GD4473@linux-mips.org>
References: <exportbomb.1187270320@pinky> <0b4bc89aa61d97708ca0f79ba02f6e60@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b4bc89aa61d97708ca0f79ba02f6e60@pinky>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 02:18:45PM +0100, Andy Whitcroft wrote:

> Seems that a trailing ';' has slipped onto the end of the access_ok
> check here, such that we will always return -EFAULT.

Ilpo Järvinen has sent an identical patch earlier which I have already
applied.  Thanks anyway,

  Ralf
