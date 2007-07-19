Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbXGSJvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbXGSJvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXGSJu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:50:57 -0400
Received: from smtp-dmz-234-thursday.dmz.nerim.net ([195.5.254.234]:57299 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752120AbXGSJu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:50:57 -0400
X-Greylist: delayed 4000 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 05:50:56 EDT
Date: Thu, 19 Jul 2007 09:42:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Greg KH <gregkh@suse.de>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
Message-ID: <20070719094259.6f654707@hyperion.delvare>
In-Reply-To: <jeir8hqxmj.fsf@sykes.suse.de>
References: <20070715124232.4e371bf9@hyperion.delvare>
	<20070717034844.GB11602@suse.de>
	<20070717131255.71b7e72e@hyperion.delvare>
	<20070717183652.GG9702@suse.de>
	<20070717230530.64d9a896@hyperion.delvare>
	<20070718033828.GA8582@suse.de>
	<20070718220652.15ad2c4b@hyperion.delvare>
	<jeir8hqxmj.fsf@sykes.suse.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Wed, 18 Jul 2007 22:12:52 +0200, Andreas Schwab wrote:
> Jean Delvare <khali@linux-fr.org> writes:
> > Maybe getmntent(3)? Sure I could use this, but how expensive compared
> > to a single stat(2).
> 
> How about comparing the device numbers of /sys and its parent?  If they
> are different then /sys is a mount point.

Nice trick, thanks. It's slightly more expensive than my current code
(two calls to stat(2) instead of one) but also more reliable. I'll
consider it when we get rid of libsysfs.

-- 
Jean Delvare
