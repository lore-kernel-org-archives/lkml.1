Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbXJYJdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbXJYJdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXJYJdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:33:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970AbXJYJdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:33:40 -0400
Message-ID: <472062E7.2030603@redhat.com>
Date: Thu, 25 Oct 2007 11:33:27 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org,
       Marek Dabek <marek.dabek@intel.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
References: <471CDC5E.4010300@linux.intel.com> <200710230030.03705.maximlevitsky@gmail.com>
In-Reply-To: <200710230030.03705.maximlevitsky@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> Will integrated sensors on DG965 motherboard be supported?
> They can be accessed only through the
> HECI interface, but the board has no AMT, and even if it had one, I don't 
> think AMT includes HW sensors.

While talking about AMT ...

<ad>

While talking about AMT:  One quite useful thing is AMT provides is
*remote* management (most useful for kernel hackers: serial-over-lan
console, remote reset).  I've hacked up some tools to use this stuff.
Package is is called amtterm.

Source code: http://dl.bytesex.org/releases/amtterm/

Fedora 7+8 have ready-to-go packages in the repositories, so you can
just "yum install amtterm".

SuSE packages are in the buildservice:
http://download.opensuse.org/repositories/home:/kraxel/

</ad>

HTH,
  Gerd
