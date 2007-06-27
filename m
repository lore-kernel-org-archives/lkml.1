Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbXF0TmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbXF0TmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXF0TmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:42:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbXF0TmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:42:04 -0400
Message-ID: <4682BD79.8080904@redhat.com>
Date: Wed, 27 Jun 2007 15:41:45 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: corentincj@iksaif.net, sziwan@users.sourceforge.net,
       acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops on rmmod asus_acpi
References: <Pine.LNX.4.64.0706272113120.11120@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706272113120.11120@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2007 03:16 PM, Jan Engelhardt wrote:
> Hi,
> 
> 
> 
> 	modprobe asus_acpi
> 	rmmod asus_acpi
> 
> is all that is needed to trigger an Oops in 2.6.22-rc6 (x86).
> If you need more info, please let me know, thanks.
> 
> Note that the machine is not ASUS at all (vmware).
> (But suse_factory loads asus_acpi anyway -wtf?!)

Probably just like Fedora 6: rc.sysinit has:

# Initialize ACPI bits
if [ -d /proc/acpi ]; then
    for module in /lib/modules/$unamer/kernel/drivers/acpi/* ; do
        module=${module##*/}
        module=${module%.ko}
        modprobe $module >/dev/null 2>&1
    done
fi
