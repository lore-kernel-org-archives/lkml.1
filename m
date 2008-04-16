Return-Path: <linux-kernel-owner+w=401wt.eu-S1764045AbYDPNwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764045AbYDPNwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763968AbYDPNw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:52:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45622 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764656AbYDPNwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:52:25 -0400
Date: Wed, 16 Apr 2008 06:52:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Neal Becker <ndbecker2@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [newb] mmap pci
Message-ID: <20080416065217.22691d34@laptopd505.fenrus.org>
In-Reply-To: <fu4njh$4aa$1@ger.gmane.org>
References: <fu4njh$4aa$1@ger.gmane.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 07:23:29 -0400
Neal Becker <ndbecker2@gmail.com> wrote:

> We have a device - an FPGA board on PCI bus.  It has a range of
> internal memory mapped to PCI.  I want to expose this to user via
> mmap.  Is there some example code someone could point me to?
> 
> If this is not the best forum for such questions, what would be a
> better choice?

Hi,

if it's just a PCI bar, you can already memory map it without even writing a driver!
You can just use the sysfs files for this, for example
/sys/devices/pci0000:00/0000:00:02.0/resource1

There's also a way to do this via the /proc representation of the PCI device..

Greetings,
   Arjan van de Ven


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
