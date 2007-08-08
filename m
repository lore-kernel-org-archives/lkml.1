Return-Path: <linux-kernel-owner+w=401wt.eu-S935907AbXHHC72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935907AbXHHC72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 22:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbXHHC7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 22:59:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:14615 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134AbXHHC7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 22:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eDFFH4ro3eV9Lb6Cv7ugSVlrsgTa42vFxk2Rei4uEp6PE41JQAwLkRz5hvE8dlHjUiVNYgZNZVoMvc8EH5qfR/jhET62dXt+LjXiNABSSZX3+ShXaASx/am+V+IMagqEJQg76zqU3vjUqgCuJ7trDM0ZZoADYlZi40N58UN/wss=
Message-ID: <86802c440708071959w6412533au4560780b7c7cac0@mail.gmail.com>
Date: Tue, 7 Aug 2007 19:59:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
Cc: "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       riku.seppala@kymp.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46B91A94.7000509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com> <200708050140.49590.ak@suse.de>
	 <20070805050410.GB4960@rhun.haifa.ibm.com>
	 <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com>
	 <20070805075307.GA25890@rhun.haifa.ibm.com>
	 <20070807154911.5fe93b40.akpm@linux-foundation.org>
	 <20070807225635.GJ4278@rhun.haifa.ibm.com>
	 <46B911C4.8010909@garzik.org>
	 <86802c440708071809g7a204200lde6f027a1bf496e9@mail.gmail.com>
	 <46B91A94.7000509@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Jeff Garzik <jeff@garzik.org> wrote:
>
> My PCI domains patch add support for multiple peer root buses.  That's
> the definition of PCI domain support.

one one segment, we can not have multi peer root buses?

>
> Branch 'pciseg' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

is your test system based AMD opteron..., and have io device on other
node/link, and use mmconfig to access that root bus on different
segment?

I used to think that we need bigSMP to support pci segments on AMD platfrom.

YH
