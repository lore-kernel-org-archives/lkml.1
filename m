Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZJ2Rv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZJ2Rv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 13:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZJ2Rv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 13:51:57 -0400
Received: from outbound-mail-104.bluehost.com ([69.89.22.14]:55375 "HELO
	outbound-mail-104.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751972AbZJ2Rv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 13:51:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oYTBgo25ggi+LNdJOUSisMQ0/76xn6wLVMH8Ga65Ip7J8FPM4uLIsGT+MkLBPp5uJtOOAPFibXOfEKBE+kO3bXNDOpEqsswWp29Aag2KUWxWgg7jPjflNOKtb/OTdGhl;
Date: Thu, 29 Oct 2009 10:51:57 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 1/2] pci: release that leaf bridge' resource index is
 not used -v6
Message-ID: <20091029105157.0e160c6b@jbarnes-g45>
In-Reply-To: <4AE9CC7E.10701@kernel.org>
References: <4ADEB601.8020200@kernel.org>
	<4AE52B68.3070501@jp.fujitsu.com>
	<4AE53883.3070709@kernel.org>
	<4AE5545E.1020900@jp.fujitsu.com>
	<4AE55D12.30403@kernel.org>
	<4AE57976.4060107@jp.fujitsu.com>
	<4AE5E37F.8070707@kernel.org>
	<4AE5EFDB.2060908@kernel.org>
	<4AE80170.6030402@jp.fujitsu.com>
	<4AE88305.8020207@kernel.org>
	<m1ljivibrt.fsf@fess.ebiederm.org>
	<4AE899A0.3020006@kernel.org>
	<4AE95247.8080401@jp.fujitsu.com>
	<4AE952B9.1010603@kernel.org>
	<4AE9588E.90708@jp.fujitsu.com>
	<4AE965C0.30206@kernel.org>
	<20091029093144.6ef9da98@jbarnes-g45>
	<4AE9CC7E.10701@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 10:10:22 -0700
Yinghai Lu <yinghai@kernel.org> wrote:
> > Also I wonder if we need to make this a command line option that
> > isn't run by default?
> 
> thinking:
> 1. try not to touch bridge resource and do the allocation and record
> the fail device 2. release leaf bridge for those failed device
> 3. do second around bus_size and allocation.

Yeah, that would make it more automatic at least, which would be nice.

> > Really, as Eric says, we need a real dynamic allocation system with
> > the ability to move devices around at some point.  Any
> > volunteers? :)
> 
> that will need suspend driver and rescan allocation and wakeup
> driver...

Right, it's fairly invasive.  But it's the right direction to go long
term.

-- 
Jesse Barnes, Intel Open Source Technology Center
