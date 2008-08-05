Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYHEDrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYHEDrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYHEDq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:46:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:48293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYHEDqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:46:55 -0400
Date: Mon, 4 Aug 2008 20:46:11 -0700
From: Greg KH <greg@kroah.com>
To: Cliffe <cliffe@ii.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Eric Paris <eparis@redhat.com>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access
	scanning
Message-ID: <20080805034611.GA11399@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain> <4897BFB4.9090309@schaufler-ca.com> <4897C2A7.7020601@ii.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897C2A7.7020601@ii.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 11:01:59AM +0800, Cliffe wrote:
> If we had stackable LSMs then the required functionality could simply be 
> built into the LSM interface. Then the anti-malware would simply stack 
> itself with other LSMs.

Could it really?  How would such an interface work?

Remember, the big issue here isn't the kernel "hooks", but the fact that
a lot of people are yet to be convinced that something like this needs
to be within the kernel itself.

Perhaps we should dig up the proposals for the filesystem-notify type
patches, something like that might be all the majority of the virus
people need, as they want to just scan things for Windows viruses, not
Linux ones, and to do so "lazily" might be sufficient.

thanks,

greg k-h
