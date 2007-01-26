Return-Path: <linux-kernel-owner+w=401wt.eu-S1030723AbXAZEuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030723AbXAZEuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 23:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030737AbXAZEuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 23:50:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030723AbXAZEuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 23:50:17 -0500
Date: Thu, 25 Jan 2007 20:47:33 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kristian =?UTF-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: Juju
Message-Id: <20070125204733.1ae70031.zaitcev@redhat.com>
In-Reply-To: <45B968E7.1070402@s5r6.in-berlin.de>
References: <20070124223745.33278eb4.zaitcev@redhat.com>
	<45B91EAB.9080004@redhat.com>
	<20070125153824.8d7f50c5.zaitcev@redhat.com>
	<45B968E7.1070402@s5r6.in-berlin.de>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 03:35:19 +0100, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> The fundamental thing about SBP-2 is that ORBs ( = SCSI command blocks
> plus SBP-2 header) and data buffers all reside in the memory of the
> initiator (or of a 3rd party on the FireWire bus).

I recognize the concept, I worked with SRP in Infiniband a bit.

> The target wrote an SBP-2 status block into our memory. The status block
> contains the FireWire bus address of the ORB to which it belongs. [...]

I see. SRP has a more flexible tag which can be used to look up
the just completed command more effectively. But if we only submit
one, it's a moot point of course.

> [...] Since there aren't many
> mapped ORBs per target, a linked list is a reasonable data structure to
> search over.

Righto. I'm used to having thousands of oustanding commands in arrays.

-- Pete
