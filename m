Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbYG1WE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbYG1WE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYG1WES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:04:18 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:58178 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752326AbYG1WES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:04:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=GlE8lVaWMHwzjKGuhpB351ID846K0ONA4LOzlGsLK5ozC2ZkTHe3VePLc9CLC4xuI/iinnZc8sVFnLloCMpgrVLy2xQjgX7cFKnCvF3+L5LTGL4QQDnirP2fCtZW1Xj4;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Date: Mon, 28 Jul 2008 15:04:08 -0700
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, David Vrabel <david.vrabel@csr.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
References: <4860D09D.4060801@csr.com> <20080725165655.GC17093@parisc-linux.org> <20080728115910.46f0669e@brian.englab.brq.redhat.com>
In-Reply-To: <20080728115910.46f0669e@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281504.08235.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I agree.  I think it's fine to have this limitation.
>
> I can imagine this being a problem e.g. for people wanting to isolate
> selected CPUs from interrupts for realtime tasks.

And they'll still be able to do this; they'll just need to use hardware that 
supports proper masking or make sure their interrupts are targetted at the 
right CPU from the start.

Jesse
