Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbZIRR6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbZIRR6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbZIRR6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:58:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbZIRR6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:58:49 -0400
Message-ID: <4AB3CA27.1040307@zytor.com>
Date: Fri, 18 Sep 2009 10:57:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Alan Cox <alan@linux.intel.com>, Amit Shah <amit.shah@redhat.com>,
       rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic
 guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>	<20090911170010.34c80f2d@linux.intel.com>	<20090911163806.GB25535@amit-x200.redhat.com>	<4AAA8838.1080106@codemonkey.ws>	<20090911173307.GB27046@amit-x200.redhat.com>	<4AAA8A56.3040707@codemonkey.ws>	<20090916112332.6bf981a5@linux.intel.com>	<4AB164A0.8000402@codemonkey.ws> <20090918170048.53ba8cf6@linux.intel.com> <4AB3C988.2040303@codemonkey.ws>
In-Reply-To: <4AB3C988.2040303@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2009 10:55 AM, Anthony Liguori wrote:
> 
> I fail to see how this is at all relevant.  This is a virtual machine,
> we're presenting virtual hardware that behaves like a serial device. 
> Where web servers fit in is completely beyond me.
> 

s/virtio_console/virtio_serial/

There is a fairly noticeable difference between a "console device" and a
"serial device".  However, something that can be extended and exported
to a physical serial port is definitely the latter.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

