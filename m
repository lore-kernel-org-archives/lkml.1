Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbYAWRcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbYAWRcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbYAWRZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:25:18 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37769 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756104AbYAWRZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:25:16 -0500
Date: Thu, 24 Jan 2008 02:25:15 +0900 (JST)
Message-Id: <20080124.022515.226770887.ryov@valinux.co.jp>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 0/2] dm-band: The I/O bandwidth controller: Overview
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <1201098755.6341.54.camel@lappy>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
	<1201098755.6341.54.camel@lappy>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> What definition of bandwidth does it use? Does it for example account
> for seek latency?

The bandwidth in dm-band is determined by the proportion of the
processing time of each device's tokens(I/Os) to the processing time
of all device's tokens(I/Os).
The processing time of one token(I/O) is determined by one I/O cycle 
include seek latency, interrupt latency, etc...

Thanks,
Ryo Tsuruta <ryov@valinux.co.jp>
