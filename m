Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbZJPNFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbZJPNFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759157AbZJPNFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:05:50 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50706 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbZJPNFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:05:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z1UzBCm7kh/WfNxa6/40vOigac79Wz/wI0hmQTcH5N6WRRLK7OK/MBiWvmvDNvc5CU
         chq5CGN3JJNb5U8mObsS+RQKIMaDJ/XG2IpTTLe2ejlb4tJ8226HHybakvHwGVWAdCrh
         LdjQl9QmUhUS3YI0PXvuQ+7BJ27FoVlhtBClU=
Date: Fri, 16 Oct 2009 15:05:10 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: x86, amd: Get multi-node CPU info from NodeId MSR instead of
 PCI config space
Message-ID: <20091016130510.GF8387@alberich.amd.com>
References: <20091016122229.GB8387@alberich.amd.com>
 <20091016123853.GA15393@elte.hu>
 <20091016125700.GD8387@alberich.amd.com>
 <20091016130000.GC24518@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016130000.GC24518@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 03:00:00PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <herrmann.der.user@googlemail.com> wrote:
> 
> > > are there any such CPUs?
> > 
> > Only Magny-Cours so far.
> > 
> > > I.e. we want to know the effect of this patch on various models of 
> > > AMD CPUs - is the change really .32 safe? Does it solve any problem 
> > > that makes it .32 material versus being for .33?
> > 
> > IMHO getting rid of the PCI config space accesses as soon as possible 
> > is a benefit, I think.
> 
> Agreed.
> 
> Is the patch an identity transformation? Or are there CPUs where the 
> information from the PCI config space is different from the MSR derived 
> one?

On production hardware it's an identity transformation.


Regards,
Andreas
