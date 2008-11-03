Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYKCNn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYKCNn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYKCNnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:43:17 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:3093 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbYKCNnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:43:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lnAKFEdQq5I9SQ21S1NUGx9GE03MplL0DyQM7uSfyzzSuYnBIgeWj8Rh1usSp0Z6LN
         l1FOHFLmuSmuJgQK4OwwMkkiyVyjfd7278A0vc1kKYLeOiswAtjfDvHxo1ijpJyVPUsX
         8raYoxiRbq6TSv/SVUNxpWRadHX1h16cV07QY=
Message-ID: <b637ec0b0811030543p997e7ddg7949069553c731f3@mail.gmail.com>
Date: Mon, 3 Nov 2008 14:43:14 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH v2] Add option to passively listen for PCIE hotplug events
Cc: "Grant Grundler" <grundler@parisc-linux.org>, linux-pci@vger.kernel.org,
       kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081103132606.GA30537@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081029200903.GA1678@srcf.ucam.org>
	 <20081101175152.GG13302@colo.lackof.org>
	 <20081103132606.GA30537@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Nov 3, 2008 at 2:26 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Various pieces of hardware (such as the Acer Aspire One and Asus EEE)
> use PCIE hotplug to change the state of devices in response to events
> such as the removal of SD cards or disabling the wireless radio.
> However, they do not provide firmware support for this. As a consequence
> pciehp will refuse to load and various things break.
>
> The existing workaround has been to use the pciehp_force option. This is
> undesirable as there is little guarantee that manipulating the power
> file in the slot directory will actually result in anything happening,
> leading to potential user confusion and hardware damage. This patch adds
> a new option, pciehp_passive. In this configuration pciehp will listen
> for events and notify the PCI core appropriately. However, it will not
> provide any user controllable sysfs attributes and so the risk of
> confusion or damage is averted. Any system slots that do have firmware
> support will continue to provide full functionality.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
>

On my system (a hp laptop) I have to use pciehp_force=1 to have the
service driver hpdriver loaded and an IRQ (MSI-Edge) assigned.

Does this patch mean that in the future I'd have to use the new
pciehp_passive=1 switch instead?

Sorry if I wasn't clear, I'm not an English native speaker.

Regards,
Fabio
