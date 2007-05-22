Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXEVETK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXEVETK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXEVES6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:18:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58768 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbXEVES5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:18:57 -0400
Date: Tue, 22 May 2007 05:18:53 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ken Chen <kenchen@google.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Message-ID: <20070522041853.GG4095@ftp.linux.org.uk>
References: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net> <20070522001851.GE4095@ftp.linux.org.uk> <b040c32a0705211830h127dfd8dk8930de6655d37d90@mail.gmail.com> <20070522014822.GF4095@ftp.linux.org.uk> <b040c32a0705211914w3843bd46o542476be97e0b6cf@mail.gmail.com> <b040c32a0705211940xe7cdf1cnb2c882edacc17a27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0705211940xe7cdf1cnb2c882edacc17a27@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 07:40:14PM -0700, Ken Chen wrote:
> tested, like this?
 
ACK.  Could merge loop_init_one() into the only remaining caller,
but it won't make the code simpler, so let's leave it at that.
