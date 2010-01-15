Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab0AORz1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 12:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908Ab0AORzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 12:55:25 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:60504 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751709Ab0AORzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 12:55:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=o/2sCSml4XHfCi3RRGrvlFbpATknyJS5TB1OyZ4yzpFTbfTj2KwnzkHTq+K7/J5zYy5RBXpbJO7+CXcZXdoPnZajRZPA4ZeIzjtTzuLE3lp6QcNuGcMvQ6P0dstlPqmC;
Date: Fri, 15 Jan 2010 09:55:20 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Moore, Robert" <robert.moore@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 1/9] PCI PM: Add function for checking PME status of
 devices
Message-ID: <20100115095520.5093e55a@jbarnes-piketon>
In-Reply-To: <201001101435.18200.rjw@sisk.pl>
References: <201001101431.38630.rjw@sisk.pl>
	<201001101435.18200.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 14:35:18 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add function pci_check_pme_status() that will check the PME status
> bit of given device and clear it along with the PME enable bit.  It
> will be necessary for PCI run-time power management.
> 
> Based on a patch from Shaohua Li <shaohua.li@intel.com>
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied this series to my linux-next branch, thanks Rafael.

-- 
Jesse Barnes, Intel Open Source Technology Center
