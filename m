Return-Path: <linux-kernel-owner+w=401wt.eu-S1422630AbXDCSl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422630AbXDCSl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422639AbXDCSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:41:59 -0400
Received: from crown.reflexsecurity.com ([72.54.139.163]:59297 "EHLO
	crown.reflexsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422630AbXDCSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:41:58 -0400
X-Greylist: delayed 2430 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 14:41:58 EDT
X-Reflex-Keepalives: .
Date: Tue, 3 Apr 2007 14:01:06 -0400
From: Jason Lunz <lunz@falooley.org>
To: roland <devzero@web.de>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel release ?
Message-ID: <20070403180105.GA5410@metaxa.reflex>
References: <023901c775ca$1608d670$eeeea8c0@aldipc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <023901c775ca$1608d670$eeeea8c0@aldipc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:28:40AM +0200, roland wrote:
> what is the real advantage to package uml-kernel and rootfs into a single 
> file ?
> 
> If this needs to be distributed with additional script, that's two files, 
> anyway.

If a common means of doing this were widespread, the script would be
distributed separately (probably with the uml utilities). Analagous to
the way bootloaders are separate from linux on real hardware.

That way, the distributor of a virtual machine would only distribute
that single system image. The user would boot it using the script
according to his own host environment.

Jason
