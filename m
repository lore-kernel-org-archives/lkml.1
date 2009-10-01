Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZJAN1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZJAN1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 09:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZJAN1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 09:27:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:43138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbZJAN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 09:27:34 -0400
Date: Thu, 1 Oct 2009 06:27:09 -0700
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers-core: nullify private pointer on device-release
Message-ID: <20091001132709.GA2221@kroah.com>
References: <Pine.LNX.4.64.0910010950330.4408@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910010950330.4408@axis700.grange>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 10:02:08AM +0200, Guennadi Liakhovetski wrote:
> Device structures can be reused over multiple device_add / device_release 
> cycles.

They shouldn't be as they should be dynamic, not static.

What device is having this problem?

thanks,

greg k-h
