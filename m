Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZLBPPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZLBPPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZLBPPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:15:03 -0500
Received: from verein.lst.de ([213.95.11.210]:46933 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbZLBPPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:15:01 -0500
Date: Wed, 2 Dec 2009 16:14:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Len Brown <lenb@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zhang Rui <rui.zhang@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical temperature
Message-ID: <20091202151425.GA20008@lst.de>
References: <20091125102857.GA28310@lst.de> <alpine.LFD.2.00.0911251647000.3950@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911251647000.3950@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 04:56:19PM -0500, Len Brown wrote:
> > I've done some attempts at bisecting it, but for most of the 2.6.32-rc
> > series the system crashes during boot in ACPI code with a backtrace
> > longer than the screen can display.
> 
> Hmm, I don't have a T500, but I've not seen such crashes during -rc.
> Please send along your .config
> Do you still get them when disabling the thinkpad-acpi driver?

I managed to boot 2.6.32-rc1 nd 2.6.32-rc2 with thinkpad-acpi disabled.
Both of them show the shutdown propblem, I'm now looking into bisecting
it further.

