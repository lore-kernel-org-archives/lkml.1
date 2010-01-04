Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879Ab0ADXxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0ADXxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280Ab0ADXxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:53:14 -0500
Received: from outbound-mail-316.bluehost.com ([67.222.54.9]:41400 "HELO
	outbound-mail-316.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752219Ab0ADXxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:53:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Zlo3KJytlVMosxHkXocAX3BFqkLCRaP2PRkERUS8EltK0QI9IhovTjoJyxRMsqNpGLH+JWONriq8CcCaXyPpwRcTzbgjdzRMIYWM4rcviLEnIcsIP4dPBprvULQ263JQ;
Date: Mon, 4 Jan 2010 15:53:08 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: andrew.patterson@hp.com, andi@firstfloor.org, ying.huang@intel.com,
       kent.liu@intel.com, youquan.song@intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [Resend PATCH]PCIe AER: reject aer inject if hardware mask
 error reporting
Message-ID: <20100104155308.04801fe4@jbarnes-piketon>
In-Reply-To: <20091217132248.GC11466@youquan-linux.bj.intel.com>
References: <20091211234855.GB7196@youquan-linux.bj.intel.com>
	<1260836954.19155.84.camel@bluto.andrew>
	<20091217132248.GC11466@youquan-linux.bj.intel.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 08:22:48 -0500
"Youquan,Song" <youquan.song@linux.intel.com> wrote:

> Correcteable/Uncorrectable Error Mask Register are used by PCIe AER
> driver which will controls the reporting of idividual errors to PCIe
> RC via PCIe error messages. 
> 
> If hardware masks special error reporting to RC, the aer_inject
> driver should not inject aer error.
> 
> Signed-off-by: Youquan, Song <youquan.song@intel.com>
> Acked-by: Ying, Huang <ying.huang@intel.com>
> ---

Applied this to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
