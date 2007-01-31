Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbXAaKkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbXAaKkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbXAaKkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:40:05 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55604 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932965AbXAaKkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:40:04 -0500
Message-ID: <45C07202.3090308@garzik.org>
Date: Wed, 31 Jan 2007 05:40:02 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Divy Le Ray <None@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/10] cxgb3 - FW versioning
References: <20070131034345.8574.21031.stgit@localhost.localdomain>
In-Reply-To: <20070131034345.8574.21031.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You need to submit a patch to remove the following ioctls:

CHELSIO_SETREG:
CHELSIO_GETREG:
CHELSIO_SET_QSET_PARAMS: (use ethtool instead)
CHELSIO_GET_QSET_PARAMS: (use ethtool instead)
CHELSIO_SET_QSET_NUM: (use ethtool instead)
CHELSIO_GET_QSET_NUM: (use ethtool instead)
CHELSIO_SETMTUTAB:
CHELSIO_GET_MEM:
CHELSIO_SET_TRACE_FILTER:
CHELSIO_SET_PKTSCHED:

explain and possibly remove

CHELSIO_GET_PM:
CHELSIO_SET_PM:

honestly it looks like just about every ioctl except load-firmware should go


