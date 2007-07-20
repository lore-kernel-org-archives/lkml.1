Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXGTVcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXGTVcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXGTVcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:32:42 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:36687 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbXGTVcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WmHhXSYyE3fx/NsbScAg9WKAFuPpHwslSzvDWgAxzWWGviT9NiSHY5e3RXmnIk07kWgdpHuZfaHFuBe4+cFTAude3XFhJ+Glfsxlrks4Aznlc1y7jye/ksqRlmwKJvgsdbU0NBurnqC7AZxWzE/Lof2UVwibpHDTNhp2jARGVAE=
Message-ID: <1a297b360707201432q3dc976b3x214c2916ca235b6f@mail.gmail.com>
Date: Sat, 21 Jul 2007 01:32:36 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Cc: "Leech, Christopher" <christopher.leech@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net, jeff@garzik.org,
       "Williams, Dan J" <dan.j.williams@intel.com>
In-Reply-To: <adazm1qai0m.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BD524EA7912ED5469DFD0BAEF6BC752F023E842F@orsmsx411.amr.corp.intel.com>
	 <adazm1qai0m.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > This driver supports some chipsets that do MSI, and some that do MSI-X,
>  > but none that can do both.
>
> Thanks, that's the simple answer I was hoping for.  Obviously if some
> chipsets only do MSI then you need the MSI code in addition to the
> MSI-X code.

In a case where you have a device that which supports MSI-X (multiple
interrupts) but the device in default is in MSI mode, ie some
configuration change is needed on the device. In such a case, how
would one handle between MSI-X and MSI ?

ie the device initially doesn't support MSI-X
