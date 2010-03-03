Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0CCXkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:40:11 -0500
Received: from kroah.org ([198.145.64.141]:54024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab0CCXkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:40:07 -0500
Date: Wed, 3 Mar 2010 15:39:58 -0800
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: Re: Ringbuffer usage in Linux Hyper-V drivers
Message-ID: <20100303233958.GA16513@kroah.com>
References: <1FB5E1D5CA062146B38059374562DF725A908A11@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20100217235223.GG12197@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56212EE39C0@TK5EX14MBXC116.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56212EE39C0@TK5EX14MBXC116.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 04:42:27PM +0000, Hank Janssen wrote:
> The ring buffer in the Hyper-V Linux drivers is used to communicate with the 
> parent partition running Server 2008 Hyper-V. The ring buffer functionality on 
> the Hyper-V Linux drivers is written to be functionally compatible with" the 
> ring buffer functionality on the Hyper-V Server. Consequently, it is not 
> possible to make any changes that might break the compatibility with server 
> side ring buffer implementation.  

Ok, that makes sense, feel free to remove that TODO item.

thanks for looking into this.

greg k-h
