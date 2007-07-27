Return-Path: <linux-kernel-owner+w=401wt.eu-S935985AbXG0Kxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935985AbXG0Kxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXG0KxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:53:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48959 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbXG0KxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:53:24 -0400
X-Greylist: delayed 1021 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 06:53:24 EDT
Date: Fri, 27 Jul 2007 11:18:24 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/68] 0 -> NULL, for arch/arm
Message-ID: <20070727101824.GB27001@flint.arm.linux.org.uk>
References: <200707270944.LAA17082@ifs.emn.fr> <20070727095905.GU27237@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727095905.GU27237@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 10:59:05AM +0100, Al Viro wrote:
> On Fri, Jul 27, 2007 at 11:44:07AM +0200, Yoann Padioleau wrote:
> >  		buf = alloc_safe_buffer(device_info, ptr, size, dir);
> > -		if (buf == 0) {
> > +		if (buf == NULL) {
> 
> 		if (!buf)
> surely...

Definitely the preferred form.

Yoann, please remember to CC folk.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
