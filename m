Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYBEGuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYBEGuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYBEGuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:50:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:55664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYBEGup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:50:45 -0500
Date: Mon, 4 Feb 2008 22:45:47 -0800
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: greg@kroah.com, markus.rechberger@amd.com,
       "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>,
       Jos?? Luis Tall??n <jltallon@adv-solutions.net>,
       "Douglas_Warzecha@dell.com" <Douglas_Warzecha@dell.com>,
       "Abhay_Salunke@dell.com" <Abhay_Salunke@dell.com>,
       linux-kernel@vger.kernel.org,
       Michael E Brown <Michael_E_Brown@dell.com>
Subject: Re: FW: 2.6.24 breaks BIOS updates on all Dell machines
Message-ID: <20080205064547.GA20384@suse.de>
References: <20080129184129.GA23681@kroah.com> <xJSmDwPr.1201644922.4322840.khali@gcu-squad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xJSmDwPr.1201644922.4322840.khali@gcu-squad.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 11:15:22PM +0100, Jean Delvare wrote:
> >So, I'm all for reverting this patch.
> >
> >And then, feel free to revisit the problem by proposing something that
> >doesn't break existing users of the interface.
> 
> I'm a bit confused. It seems to me that the "class devices" are named
> differently in recent kernels. The i2c-dev class devices were originally
> showing as i2c-%d in their parent device directories (causing the
> collision), and now show as i2c-dev:i2c-%d. This suggests that the
> collision the patch above was trying to solve is in fact already fixed
> (by prefixing the device name with the class name). The good news is
> that it would mean that we can just revert the patch in question...
> 
> But quite frankly I'm not really sure, the class devices look different
> on every kernel I looked at, depending on the version and whether
> CONFIG_SYSFS_DEPRECATED is set or not.

THe naming is different depending on that sysfs variable, yes.  But it
should be consistant other than that.  If not, please let me know.

And yes, we did have to add the ":" a while ago to handle the namespace
collisions we were having.

thanks,

greg k-h
