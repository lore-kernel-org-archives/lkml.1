Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYAWOcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYAWOcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYAWOcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:32:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35378 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYAWOco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:32:44 -0500
Subject: Re: [PATCH 0/2] dm-band: The I/O bandwidth controller: Overview
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
In-Reply-To: <20080123.215350.193721890.ryov@valinux.co.jp>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 15:32:35 +0100
Message-Id: <1201098755.6341.54.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 21:53 +0900, Ryo Tsuruta wrote:
> Hi everyone,
> 
> I'm happy to announce that I've implemented a Block I/O bandwidth controller.
> The controller is designed to be of use in a cgroup or virtual machine
> environment. The current approach is that the controller is implemented as
> a device-mapper driver.

What definition of bandwidth does it use? Does it for example account
for seek latency?


