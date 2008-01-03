Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYACNQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYACNQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYACNQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:16:23 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:35088 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYACNQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:16:23 -0500
Date: Thu, 3 Jan 2008 14:16:21 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080103131620.GA16307@boogie.lpds.sztaki.hu>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102151642.GA7273@boogie.lpds.sztaki.hu>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 04:16:42PM +0100, Gabor Gombas wrote:

> So the patch referenced above does not help. But I've found a very easy
> way to trigger the bug:
> 
> - do a "cat /dev/zero > /dev/rfcomm0"
> - switch the phone off
> - switch the phone on, and the kernel oopses

FYI I also remember having oopses with 2.6.22.<something> but I do not
have those logs anymore. Also I now booted 2.6.20.7 and it did not oops.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
