Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYJ3QOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYJ3QOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbYJ3QOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:14:18 -0400
Received: from outbound-mail-122.bluehost.com ([67.222.38.22]:54608 "HELO
	outbound-mail-122.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757224AbYJ3QOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:14:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=FgtYO414sowItweziQQB38e6AWpCHPyLJ0OvCwdwVmEx/MJEcUlI6+RY57jjByW0BpVfnSY1EvmqJ8/65CtqvVdXPoHKP46/OE+1GVO/8fM5bGpls0wqyPAQuZ6TEsK9;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH] PCI: Limit VPD length for Broadcom 5708S
Date: Thu, 30 Oct 2008 09:14:03 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>, benli@broadcom.com,
       "willy@linux.intel.com" <willy@linux.intel.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
References: <48920413.6080508@cosmosbay.com> <4906AF5F.9040704@cosmosbay.com> <20081028064411.GA7043@yzhao12-linux.sh.intel.com>
In-Reply-To: <20081028064411.GA7043@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810300914.03885.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 27, 2008 11:44 pm Yu Zhao wrote:
>
> VPD quirks needs to be called after the capability is initialized. Since
> VPD initialization is move to after pci_fixup_header, VPD quirks should
> be done at pci_fixup_final stage correspondingly.
>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>

Thanks, I'll queue this up for the next pull.

Jesse
