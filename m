Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbYCEHaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbYCEHaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYCEHam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:30:42 -0500
Received: from mx1.suse.de ([195.135.220.2]:51389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbYCEHam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:30:42 -0500
Date: Tue, 4 Mar 2008 23:35:29 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
	should be material for 2.6.25
Message-ID: <20080305073529.GA4610@suse.de>
References: <86802c440803042104p77f44d5fnd4aeb86e21ec8c66@mail.gmail.com> <20080305070521.GB32434@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305070521.GB32434@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 08:05:21AM +0100, Ingo Molnar wrote:
> 
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > Ingo/greg,
> > 
> > one patch in x86.git#testing
> > 
> >     x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
> > 
> >     reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.
> > 
> > should be get into 2.6.25. instead of waiting for 2.6.26
> > 
> > it just one quirk to update AMD fam10h cfg_size if MMCONFIG is there.
> > 
> > otherwise lspci -vvxxxx still report 512 for those NB.
> 
> i have no objections and the patch has been in the tree for some time. 
> Greg, if you agree, could you send it to Linus. (or i can do it too if 
> you Ack the change)

Feel free to send it and add my:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
