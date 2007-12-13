Return-Path: <linux-kernel-owner+w=401wt.eu-S1765279AbXLMHXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765279AbXLMHXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764222AbXLMHN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:13:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46619 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764097AbXLMHNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:13:24 -0500
Date: Wed, 12 Dec 2007 23:12:15 -0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org
Subject: Re: [PATCH] depmod: sort output according to modules.order, take #2
Message-ID: <20071213071215.GD13764@kroah.com>
References: <475936CE.70703@gmail.com> <4759379D.8090201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4759379D.8090201@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 09:07:57PM +0900, Tejun Heo wrote:
> Kbuild now generates and installs modules.order along with modules.
> This patch updates depmod such that it sorts module list according to
> the file before generating output files.  Modules which aren't on
> modules.order are put after modules which are ordered by
> modules.order.
> 
> This makes modprobe to prioritize modules according to kernel
> Makefile's just as built-in modules are link-ordered by them.
> 
> This patch is against module-init-tools 3.3-pre1.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Bill Nottingham <notting@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
