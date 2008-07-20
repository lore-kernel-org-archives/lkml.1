Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYGTQvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYGTQvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbYGTQvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:51:33 -0400
Received: from smtp.extricom.com ([192.114.46.18]:45987 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757610AbYGTQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:51:32 -0400
X-Greylist: delayed 22581 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 12:51:31 EDT
Message-ID: <48836C52.5000309@extricom.com>
Date: Sun, 20 Jul 2008 19:48:18 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc4] PCI: refuse to re-add a device to a bus upon
 pci_scan_child_bus()
References: <48591941.4070408@extricom.com> <4883141A.4080209@extricom.com>
In-Reply-To: <4883141A.4080209@extricom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject is wrong! it is 2.6.26-rc4.

I will re-email with a corrected subject for automated scripts sake.

Liberty

Eran Liberty wrote:
> Dear Penguins,
>
> As  a follow up on my own post ( http://lkml.org/lkml/2008/6/18/195 ), 
> I have  solved a small bug/misbehavior within the 
> pci_scan_single_device().
>
> The misbehavior manifest itself upon calling pci_scan_child_bus() with 
> a bus which already contain some devices. After scanning is done 
> devices that already existed will be present twice in the PCI bus 
> devise list. Once with is_added indication and once without. Trying to 
> add this bus will cause a resource conflict as the same device is 
> already present and initialized.
>
> This patch will simply prevent a device to be added to a bus list if 
> it is already there.
>
> Points to consider:
> 1. I am not a PCI Guru and might have over looked the bigger picture. 
> Is it OK to prevent a device of being re-added?
> 2. I have decided that two devices are, in fact, the same instance if 
> it has the same: vendor, device, and devfn. Is there a finer test for 
> a device identity?
>
> p.s. As per http://www.kernel.org/pub/linux/docs/lkml/#s1-10 it is 
> preferred for Mozilla Firefox clients to attach the patch, hence my 
> patch is attached.
>
> Liberty
>
> Signed-off-by: Eran Liberty <liberty@extrictom.org>
> ---

