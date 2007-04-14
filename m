Return-Path: <linux-kernel-owner+w=401wt.eu-S1160999AbXDNCSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160999AbXDNCSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 22:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161039AbXDNCSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 22:18:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160999AbXDNCSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 22:18:05 -0400
Date: Fri, 13 Apr 2007 19:16:54 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Jeremy C. Andrus" <jeremy@jeremya.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb bulk transfer: 1024 byte packets
Message-Id: <20070413191654.1abdbafc.zaitcev@redhat.com>
In-Reply-To: <200704131256.47570.jeremy@jeremya.com>
References: <200704131256.47570.jeremy@jeremya.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 12:56:47 -0400, "Jeremy C. Andrus" <jeremy@jeremya.com> wrote:

> I recently ran into a couple of USB devices which insisted on using 1024 
> byte packets in bulk transfer mode (despite the hard limit of 512 
> established in the spec). I really wanted to use these devices, so I 
> created a kernel patch which allows the use of 1024 byte URBs, but does 
> not interfere with normal (512 byte) operation. I did this through a 
> bit in the transfer_flags bitfield.

The transfer size in the URB is not limited by the maximum packet size.
The HC driver splits up the transfer as specified by URB into the required
number of packets.

I think you might want to write to linux-usb-devel@lists.sourceforge.net
to discuss the specifics of what it mean "devices insisted on 1024".
I presume the devices didn't show up on your doorstep with baseball
bats to have a little chat. So there must be a specific failure symptom.
Until you share it, I don't see this patch going anywhere.

-- Pete
