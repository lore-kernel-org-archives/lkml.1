Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYABCOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYABCOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYABCOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:14:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894AbYABCOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:14:03 -0500
Date: Tue, 1 Jan 2008 18:12:12 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Get physical MAC address
Message-ID: <20080101181212.1e7b5ff0@deepthought>
In-Reply-To: <1199228848.3912.651.camel@gimli.at.home>
References: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th>
	<1199228848.3912.651.camel@gimli.at.home>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jan 2008 00:07:28 +0100
Bernd Petrovitsch <bernd@firmix.at> wrote:

> On Mon, 2007-12-31 at 12:39 +0700, Theewara Vorakosit wrote:
> [...]
> > I get MAC address from ioctl. However, ifconfig can change this  MAC 
> > address. Can I get a real physical MAC address of the NIC?
> 
> - You can get the initial MAC address right after bootup before anyone
>   changes it.
> - Some (if not many if not all) of the drivers output it on
>   driver initialization time so you could read it from `dmesg` or
>   some /var/log/messages or .....
> There is no "get initial MAC address" ioctl (but it's not that
> complicated to implement it).
> 
> 	Bernd

There is already ethtool interface to get what you want (ETHTOOL_GPERMADDR)


-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
