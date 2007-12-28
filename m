Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbXL1Oha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbXL1Oha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 09:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbXL1OhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 09:37:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbXL1OhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 09:37:22 -0500
Date: Fri, 28 Dec 2007 09:27:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: hbabu@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20071228142739.GA4560@redhat.com>
References: <20071228124532.GB32643@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228124532.GB32643@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 06:15:32PM +0530, Dhaval Giani wrote:
> Hi Vivek,
> 
> I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
> kexec. It just gets stuck at "Starting new kernel".
> 
> It does boot normally when booted as the first kernel.
> 
> Any hints debugging? (x86 architecture)

I generally try few things.

- Specify earlyprintk= parameter for second kernel and see if control
  is reaching to second kernel.

- Otherwise specify --console-serial parameter on "kexec -l" commandline
  and it should display a message "I am in purgatory" on serial console.
  This will just mean that control has reached at least till purgatory.

- If that also does not work, then most likely first kernel itself got
  stuck somewhere and we need to put some printks in first kernel
  to find out what's wrong.

Thanks
Vivek
