Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbXLHWRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbXLHWRG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 17:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbXLHWQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 17:16:55 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52817 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbXLHWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:16:54 -0500
Date: Sat, 8 Dec 2007 15:16:52 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nick Warne <nick@ukfsn.org>, Clemens Koller <clemens.koller@anagramm.de>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: scsi_wait_scan Kconfig option
Message-ID: <20071208221652.GA1159@parisc-linux.org>
References: <20071207191242.71a9cc3e@linuxamd.linicks.net> <475A9810.4070104@anagramm.de> <20071208162122.7e77601e@linuxamd.linicks.net> <475B0AC7.2030408@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475B0AC7.2030408@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 10:21:11PM +0100, Stefan Richter wrote:
> Besides, in order for scsi_wait_scan to work, drivers need to support it
> explicitly, don't they?  If so, simply kill the "default m" from config
> SCSI_WAIT_SCAN and let any driver which is integrated with it select it.

No.  All drivers which call scsi_scan_host() support it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
