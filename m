Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbXHAQSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbXHAQSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbXHAQSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:18:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44548 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbXHAQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:18:30 -0400
X-Sasl-enc: mJal8VFyQ+5jQIEjcvq4MgRwYQYVtUNJfgUEZ4picBQ/ 1185985108
Date: Wed, 1 Aug 2007 13:18:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-pm@linux-foundation.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc1: T60 ACPI issues
Message-ID: <20070801161825.GN23111@khazad-dum.debian.net>
References: <20070801135820.GA8266@mellanox.co.il> <Pine.LNX.4.64.0708011516540.15447@blonde.wat.veritas.com> <20070801145607.GB8480@mellanox.co.il> <20070801154749.GK23111@khazad-dum.debian.net> <20070801155510.GA11758@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801155510.GA11758@mellanox.co.il>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007, Michael S. Tsirkin wrote:
> My guess is that upon resume, I normally get some other acpi event
> which gets blocked with CONFIG_THINKPAD_ACPI_INPUT_ENABLED.

*Nothing* should be using any such events like that (that is an bug by
itself), but let's find out if that's what happening first.

acpid logs can probably tell you that.

> > Please open a bug in bugzilla.kernel.org about it, and attach the full debug
> > output of a suspend+resume cycle with and without thinkpad-acpi loaded.
> > 
> > Also, please try the same with thinkpad-acpi loaded, but
> > CONFIG_THINKPAD_ACPI_INPUT_ENABLED set to N.  If the problem goes away,
> > please retest, but set hotkey_enable to 1 and do an "cat
> > /sys/bus/platform/devices/thinkpad_acpi/hotkey_recommended_mask >
> > /sys/bus/platform/devices/thinkpad_acpi/hotkey_mask" before the sleep.
> 
> what's hotkey_enable?

/sys/bus/platform/devices/thinkpad_acpi/hotkey_enable.

Please read the full thinkpad-acpi documentation (it is in
Documentation/thinkpad-acpi.txt in the kernel tree).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
