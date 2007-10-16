Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbXJPDkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbXJPDkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 23:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbXJPDkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 23:40:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:10984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757912AbXJPDkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 23:40:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,281,1188802800"; 
   d="scan'208";a="347283574"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Date: Mon, 15 Oct 2007 20:38:09 -0700
User-Agent: KMail/1.9.7
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net>
In-Reply-To: <20071015210737.GA15293@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710152038.10980.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 15, 2007 2:07 pm Henrique de Moraes Holschuh wrote:
> We should fix the backlight class to be more useful and support
> poll() or somesuch, for userspace to track the backlight level in a
> resource-friendly way for OSD (the only sane thing to do on an IBM
> thinkpad with such events). And an ALSA mixer to provide a proper
> path to the thinkpad-acpi volume functionality is also in my schedule
> for 2.6.25.
>
> As for Lenovo thinkpads, brightness control is to be processed by the
> ACPI video module, so brightness hot keys are not to be reported by
> default there either.  I am not so sure about the volume keys, but
> your patch touches the IBM keymap *and* you provide no testing
> information for the various Lenovo models, so I have to NAK it as
> well until more information is available.

No, on Lenovo (and in general actually) the firmware should *not* touch 
the backlight.  Otherwise if another driver touches it the driver and 
firmware will be out of sync, causing unexpected and undesirable 
behavior.  We intend to fix this for the Intel driver at least 
(requiring both ACPI video driver and gfx driver updates), others will 
probably follow eventually.

Jesse
