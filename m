Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0AOR3v (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 12:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492Ab0AOR3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 12:29:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:37668 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab0AOR3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 12:29:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,279,1262592000"; 
   d="scan'208";a="531655851"
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
From: reinette chatre <reinette.chatre@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100115152215.GC2541@gamma.logic.tuwien.ac.at>
References: <20100115152215.GC2541@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 09:29:48 -0800
Message-ID: <1263576588.2751.455.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,

On Fri, 2010-01-15 at 07:22 -0800, Norbert Preining wrote:
> kernel 2.6.33-rc4
> 
> I am having repeatable complete hard lockups on my laptop with 2.6.33-rc4.
> 2.6.32.3 works fine.
> 
> I believe that it is related to the network, because sometimes I can
> actually log in (gnomes session) and as soon as I do some network
> related suddenly hard hang, not even Sysrq working anymore.
> 
> Interestingly it only happens at a specific AP where the ESSID is
> hidden (at work). At home I can work without any problems (ESSID not
> hidden).
> 
> Unfortunately I cannot set up a serial console or similar.

Does that mean no netconsole either? Does anything show up in the logs?
Is it easy to reproduce? If so, perhaps you can have increased debug at
that time and hopefully something will be captured in the logs when the
problem occurs.

> 
> Is there still anything else I can provide you for tracking that down.

Can you try to boot without X and attempt a command line association
(using iw, iwconfig or wpa_supplicant) to reproduce?

Reinette


