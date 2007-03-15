Return-Path: <linux-kernel-owner+w=401wt.eu-S1422991AbXCOWlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422991AbXCOWlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422981AbXCOWlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:41:15 -0400
Received: from mail.kroah.org ([69.55.234.183]:42662 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422991AbXCOWlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:41:14 -0400
Date: Thu, 15 Mar 2007 15:27:07 -0700
From: Greg KH <gregkh@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.2 - unable to handle kernel paging request - still accessing freed memory
Message-ID: <20070315222707.GI31713@suse.de>
References: <170606.12059.qm@web52911.mail.yahoo.com> <84144f020703140423h2562a353g40c156584943bb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020703140423h2562a353g40c156584943bb7@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 01:23:02PM +0200, Pekka Enberg wrote:
> Hi Greg,
> 
> I think there's some sort of reference counting problem with sysfs in
> 2.6.20 kernels. Can you please help us debug it further?

Is there any way you can use 'git bisect' to try to track down the root
cause of this?

thanks,

greg k-h
