Return-Path: <linux-kernel-owner+w=401wt.eu-S938135AbXG0VxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938135AbXG0VxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764920AbXG0VxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:53:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:7999 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763906AbXG0VxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FKBHeKwd6clFl5FCTpp6ZvAEpd0Y6ZzJCmQ77oB7TIFzPbICiYMmkgoVBSOg6nuPhrfF6PJW3Ht9Bb2G/czLJu5k7ALuHWLnUp7ychpmaZ5twr6eXcq/0CqvSEcpb2g9zKm7qyl/6wTHYxpDXg76gZFOsVNn5seFi2EkrERyQmo=
Message-ID: <3ae72650707271453s223bd484xd1d70ef8ad5b3d77@mail.gmail.com>
Date: Fri, 27 Jul 2007 23:53:02 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Shaohua Li" <shaohua.li@intel.com>,
       "=?UTF-8?Q?S=C3=A9bastien_Dugu=C3=A9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
In-Reply-To: <46AA5E1A.8020303@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <200707271256.17025.bjorn.helgaas@hp.com>
	 <86802c440707271335y29ca79ccq844b5cb457bd2314@mail.gmail.com>
	 <200707271458.44391.bjorn.helgaas@hp.com>
	 <46AA5E1A.8020303@garzik.org>
X-Google-Sender-Auth: 28c37804a8e89df9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Jeff Garzik <jeff@garzik.org> wrote:
> Bjorn Helgaas wrote:
> > And couldn't we use udev to associate a fixed name with a MAC
> > address?  Then the user could use the same persistent name,
> > regardless of the order in which the driver found the devices.
>
>
> I don't know about udev, but people are definitely using fixed names
> based on MAC address for ethernet devices already:  nameif(8) and
> /etc/mactab, iftab(5) and ifrename(8).

That's all obsolete with udev, it creates persistent name entries on
first device discovery, and keeps them forever.
You can edit the automatically created/updated udev rules, if you want
different names, but by default there is no intervention needed to
have stable network device names out of the box, regardless of any
kernel module loading/linking order or whatever.

Kay
