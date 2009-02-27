Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbZB0KrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbZB0KrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZB0Kqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:46:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46535
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756345AbZB0Kqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:46:54 -0500
Date: Fri, 27 Feb 2009 02:46:35 -0800 (PST)
Message-Id: <20090227.024635.51509388.davem@davemloft.net>
To: sam@ravnborg.org
Cc: christopher.leech@intel.com, linux-netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net headers: export dcbnl.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090227055506.GA7020@uranus.ravnborg.org>
References: <20090227004635.10247.60814.stgit@localhost.localdomain>
	<20090227055506.GA7020@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 27 Feb 2009 06:55:06 +0100

> On Thu, Feb 26, 2009 at 04:46:35PM -0800, Chris Leech wrote:
> > The DCB netlink interface is required for building the userspace tools
> > available at e1000.sourceforge.net
> 
> Hmmm, is that file ready for export....
> 
> >From dcbnl.h:
> #ifndef __LINUX_DCBNL_H__
> #define __LINUX_DCBNL_H__
> 
> #define DCB_PROTO_VERSION 1
> 
> struct dcbmsg {
>         unsigned char      dcb_family;
>         __u8               cmd;
>         __u16              dcb_pad;
> };
> 
> 1) It uses __u8/__u16 so it would be nice it is included <linux/types.h>
> so these are actually defined.
> 2) Why does it use "unsigned char" for one member and __u8 for another.
> It looks inconsistent.
> 
> We export headers that are much worse but we better raise the bar a little.

Agreed, we should sort out these issues before exporting.
