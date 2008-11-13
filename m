Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYKMVYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYKMVYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYKMVYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:24:15 -0500
Received: from kroah.org ([198.145.64.141]:53683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751420AbYKMVYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:24:14 -0500
Date: Thu, 13 Nov 2008 13:23:05 -0800
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-acpi@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [stable] [patch 20/23] ACPI: dock: avoid check _STA method
Message-ID: <20081113212305.GA5697@kroah.com>
References: <20081107224818.593212310@mini.kroah.org> <20081107231606.GU1108@kroah.com> <20081111121607.GA32066@homac.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111121607.GA32066@homac.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 01:16:07PM +0100, Holger Macht wrote:
> On Fri 07. Nov - 15:16:06, Greg KH wrote:
> > 2.6.26-stable review patch.  If anyone has any objections, please let us know.
> 
> Objecting. This will only work in conjunction with
> 
>   commit 39a0ad871000d2a016a4fa113a6e53d22aabf25d
>   Author: Zhao Yakui <yakui.zhao@intel.com>
>   Date:   Mon Aug 11 13:40:22 2008 +0800
> 
>       ACPI : Load device driver according to the status of acpi device
> 
> Otherwise a device struct already exists although the device is not
> present.

So do you feel we should also add this patch to the 2.6.27-stable tree
to solve this issue?

thanks,

greg k-h
