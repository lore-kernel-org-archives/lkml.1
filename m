Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbXIMP7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbXIMP7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbXIMP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:59:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbXIMP7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:59:40 -0400
Message-ID: <46E95E5D.2050305@redhat.com>
Date: Thu, 13 Sep 2007 11:59:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Possible hang inside interrupt handler on sata_promise.
References: <20070912131904.GW14474@lnx-holt.americas.sgi.com>
In-Reply-To: <20070912131904.GW14474@lnx-holt.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2007 09:19 AM, Robin Holt wrote:
> I have been experiencing hangs on a newly setup machine.  Unfortunately,
> it appears to be hanging inside the interrupt handler as sysrq and
> caps-lock led seem to stop working when the event occurs.  I am guessing
> it is related to the sata_promise driver, but that is only a guess as
> I don't get much for output.  I am running the debian unstable kernel
> (2.6.22-1-686), but the problem also occurs with the debian stable kernel
> (2.6.18-4-686).  I do need to boot with the acpi=off option, but am
> not sure if that is related.  Unfortunately, I do not know much about
> troubleshooting i386 when problems occur inside the interrupt handlers.

There is a list of kernel options you can try, including:

  noapic
  nolapic
  pci=nomsi,nommconf
  pci=noacpi

