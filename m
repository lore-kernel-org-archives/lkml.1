Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYHDN4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYHDN4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbYHDN40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:56:26 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:41048 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYHDN4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:56:25 -0400
Message-ID: <48970A4D.2090309@csr.com>
Date: Mon, 04 Aug 2008 14:55:25 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Moore, Eric" <Eric.Moore@lsi.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: Re: [PATCH 2/2] fusion:  Implement generic interrupt misroute handling
References: <1217786709.4179.27.camel@localhost.localdomain> <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
In-Reply-To: <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2008 13:55:24.0914 (UTC) FILETIME=[BE77A520:01C8F639]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moore, Eric wrote:
> Thanks, I will try this out.   However I thought I saw lost
> interrupts occurring randomly, meaning it was not necessarily the
> first config page access.  I'm back in the office on 8/11, I will
> test it out then and provide feedback.

Is this using MSI on a device without per-vector mask bits?  If so, then
this patch may help.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
