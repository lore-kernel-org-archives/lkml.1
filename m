Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYKEB5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYKEB5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 20:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYKEB45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 20:56:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:54185 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYKEB44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 20:56:56 -0500
Date: Tue, 4 Nov 2008 17:02:05 -0800
From: Greg KH <gregkh@suse.de>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [patch 51/57] ACPI: Ingore the RESET_REG_SUP bit when using
	ACPI reset mechanism
Message-ID: <20081105010205.GA26202@suse.de>
References: <20081104232144.186593464@mini.kroah.org> <20081104233325.GZ659@suse.de> <1225846092.26020.89.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225846092.26020.89.camel@yakui_zhao.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 08:48:12AM +0800, Zhao Yakui wrote:
> On Wed, 2008-11-05 at 07:33 +0800, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> Please don't apply this patch.And this causes the reboot regression on
> AMD chipset. (Bug11942)
>     Now the default reboot type is changed from BOOT_KBD to BOOT_ACPI.
>       
> On the AMD box there exists the definition of RESET_REG &RESET_VALUE,
> which is identical to the definition in Intel Chipset. After the
> RESET_REG_SUP is ignored, the AMD box can't be rebooted by writing the
> RESET_VALUE to RESET_REG I/O port.

Was there a follow-on patch that fixes the regression that has gone into
Linus's tree?  If so, wouldn't it be better to apply that as well?

Len, what do you advise here?

thanks,

greg k-h
