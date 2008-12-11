Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYLKEeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYLKEeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYLKEdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:33:53 -0500
Received: from colo.lackof.org ([198.49.126.79]:49084 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbYLKEdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:33:52 -0500
Date: Wed, 10 Dec 2008 21:33:40 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
Message-ID: <20081211043340.GA9783@colo.lackof.org>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084531.GP3773@yzhao12-linux.sh.intel.com> <20081106043235.GA30292@kroah.com> <4913AA03.5060807@intel.com> <20081107025032.GA12824@kroah.com> <4913B8A5.5010806@intel.com> <20081107041721.GB15439@parisc-linux.org> <20081211014313.GA4947@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211014313.GA4947@yzhao12-linux.sh.intel.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 09:43:13AM +0800, Yu Zhao wrote:
...
> I believe this is the only problem that preclude us having the run-time
> resource rebalance. And I'm not sure how much effort we can fix it. Any
> comments?

Figure out the right sequence for driver resume so the probe function
can call resume as well?

Document the change and then start modifying drivers one-by-one.
API changes are alot of work.

grant
