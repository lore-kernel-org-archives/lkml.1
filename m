Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbXETRms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbXETRms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbXETRmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:42:40 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:34663 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbXETRmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:42:40 -0400
Date: Sun, 20 May 2007 13:42:31 -0400
From: Jon Smirl <jonsmirl@verizon.net>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
To: Jesse Barnes <jesse.barnes@intel.com>, jonsmirl@gmail.com,
       linux-kernel@vger.kernel.org
Message-id: <pan.2007.05.20.17.41.22@gmail.com>
MIME-version: 1.0
X-Mailer: Evolution 2.8.1
Content-type: text/plain
Content-transfer-encoding: 7bit
linux-kernel%40vger.kernel.org: 
References: <200705171423.46748.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 14:23:45 -0700, Jesse Barnes wrote:

> In collaboration with the FB guys, we've been working on enhancing the
> kernel's graphics subsystem in an attempt to bring some sanity to the
> Linux graphics world and avoid the situation we have now where several
> kernel and userspace drivers compete for control of graphics devices.

How is supporting different users logged into each head going to work? 
The original model for this was to give each head its own fbdev device. 
It is important that each user be able to set their own mode without being 
root.

Jon Smirl
jonsmirl@gmail.com

