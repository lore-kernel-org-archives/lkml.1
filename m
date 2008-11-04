Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYKDMpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYKDMpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYKDMpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:45:17 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51057 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYKDMpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:45:16 -0500
Date: Tue, 4 Nov 2008 12:45:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add option to passively listen for PCIE hotplug events
Message-ID: <20081104124509.GA19401@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org> <490FAC33.9050808@jp.fujitsu.com> <20081104020700.GA11761@srcf.ucam.org> <20081104050245.GA13466@srcf.ucam.org> <490FE1AC.5030608@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490FE1AC.5030608@jp.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 02:46:20PM +0900, Kenji Kaneshige wrote:

> I can't understand why the 'value' is set to 0 when pciehp_enable_slot()
> returns error. The 'value' here is representing whether the slot is
> occupied or not. Even if pciehp_enable_slot() returns error, it doesn't
> mean slot is not occupied. So I think it is clearly wrong thing that
> changing 'value' to 0 from 1 here.
> 
> How about just ignore the return value from pciehp_enable_slot()? The
> code would be as follows.

Yeah, I agree with that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
