Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYJQXEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYJQXEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbYJQXE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:04:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45860 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756044AbYJQXE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:04:28 -0400
Date: Sat, 18 Oct 2008 00:54:41 +0200
From: Pavel Machek <pavel@suse.cz>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 8/8 v4] PCI: document the changes
Message-ID: <20081017225440.GA1467@ucw.cz>
References: <20081014103424.GA1704@yzhao12-linux.sh.intel.com> <20081014110157.GH1734@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014110157.GH1734@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Create how-to for SR-IOV user and device driver developer.
> 
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>

> +1.1 What is SR-IOV
> +
> +Single Root I/O Virtualization (SR-IOV) is a PCI Express Extended
> +capability which makes one physical device appear as multiple virtual
> +devices. The physical device is referred to as Physical Function while
> +the virtual devices are referred to as Virtual Functions. Allocation
> +of Virtual Functions can be dynamically controlled by Physical Function
> +via registers encapsulated in the capability. By default, this feature
> +is not enabled and the Physical Function behaves as traditional PCIe
> +device. Once it's turned on, each Virtual Function's PCI configuration
> +space can be accessed by its own Bus, Device and Function Number (Routing
> +ID). And each Virtual Function also has PCI Memory Space, which is
> used

Ok, why is this optional? If intel cares about virtualization, it
should enable this by default. I dont see why this should be
configurable.

> +#ifdef CONFIG_PM
> +/*
> + * If Physical Function supports the power management, then the
> + * SR-IOV needs to be disabled before the adapter goes to sleep,
> + * because Virtual Functions will not work when the adapter is in
> + * the power-saving mode.
> + * The SR-IOV can be enabled again after the adapter wakes up.
> + */

How beatiful :-(.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
