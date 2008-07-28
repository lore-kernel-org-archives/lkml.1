Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbYG1Wbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbYG1Wbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYG1Wbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:31:42 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:54395 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751270AbYG1Wbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:31:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=AhSvnZUsNKn1JdBQnrG3xvsx881jhZjsNFjL6QGfvieFjULH1IkNomPj2pYEptBy92irCsRJL2UYGmaNsafy+H/FMTZsgqR2Eze6pp07M/cc3lbFYR6tmONz5TCRtYdW;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug] PCI hotplug, ibmphp_access_ebda: WARNING: at arch/x86/mm/ioremap.c:182 __ioremap_caller+0x2d1/0x340()
Date: Mon, 28 Jul 2008 15:31:32 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, greg@kroah.com
References: <20080726131512.GA29472@elte.hu>
In-Reply-To: <20080726131512.GA29472@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281531.32640.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 26, 2008 6:15 am Ingo Molnar wrote:
> FYI, -tip testing triggered the new warning below on a testbox. I
> suspect it's related to recent commits in drivers/pci/hotplug/.
> I'm wondering, why does a driver map the EBDA? That's a really lowlevel
> thing.

AFAICT, this driver digs around in there for hotplug controller configuration 
(cc'ing Greg since he appears to be one of the original authors).  It's a 
custom platform driver too, that may be the only method available there.  Is 
there a shadow copy of the EDBA somewhere we should be using instead?

Jesse
