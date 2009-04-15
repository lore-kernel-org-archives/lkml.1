Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZDOBuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZDOBuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZDOBuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:50:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:5332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZDOBuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:50:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,188,1239001200"; 
   d="scan'208";a="681613195"
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control
	brightness with hotkeys (BISECTED)
From: Zhang Rui <rui.zhang@intel.com>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <49E5234E.5070303@gmail.com>
References: <49E10684.5090101@gmail.com>
	 <20090411150555.8b13ed18.akpm@linux-foundation.org>
	 <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com>
	 <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com>
	 <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 09:50:42 +0800
Message-Id: <1239760242.7661.305.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 07:59 +0800, Niel Lambrechts wrote:
> On 04/13/2009 10:34 PM, Henrique de Moraes Holschuh wrote:
> > On Mon, 13 Apr 2009, Niel Lambrechts wrote:
> >   
> >>>> In 2.6.29.1:
> >>>> lrwxrwxrwx 1 root root 0 Apr 12 20:01 /sys/class/backlight/acpi_video0
> >>>> -> ../../devices/virtual/backlight/acpi_video0
> >>>>         
> >
> > Well, that at least confirms that thinkpad-acpi doesn't have anything to
> > do with your troubles, you were using acpi video.
> >   
> 
> Okay, I've bisected it to:
> 
> 74a365b3f354fafc537efa5867deb7a9fadbfe27 is first bad commit
> commit 74a365b3f354fafc537efa5867deb7a9fadbfe27
> Author: Matthew Garrett <mjg59@srcf.ucam.org>
> Date:   Thu Mar 19 21:35:39 2009 +0000
> 
>     ACPI: Populate DIDL before registering ACPI video device on Intel
> 

please set CONFIG_DRM_I915_KMS, reload the ACPI video driver after
loading i915 and see if it helps.

thanks,
rui

