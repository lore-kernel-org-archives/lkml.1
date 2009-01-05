Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbZAETRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbZAETRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZAETRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:17:06 -0500
Received: from outbound-mail-316.bluehost.com ([67.222.54.9]:41890 "HELO
	outbound-mail-316.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752507AbZAETRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:17:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=g92QkDmV/UEFAt3GBelBO7dcnWjYq1ylI9ZemtfFqotWzYETh3vpVrKAh0ZW4JAuELMEMOtDeyiO6kNRl0Szxf69lX8aNanxtSBfCu5bGTf0Y6nzq5ii4U4TdSk8aalN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] ASPM: Use msleep instead of cpu_relax during link retraining
Date: Mon, 5 Jan 2009 11:17:00 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Matthew Wilcox <matthew@wil.cx>,
       Andrew Patterson <andrew.patterson@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       shaohua.li@intel.com
References: <20081222221156.29645.95982.stgit@bluto> <20081225232427.GJ19967@parisc-linux.org> <20081226182702.GA1528@ucw.cz>
In-Reply-To: <20081226182702.GA1528@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051117.00683.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 26, 2008 10:27 am Pavel Machek wrote:
> On Thu 2008-12-25 16:24:27, Matthew Wilcox wrote:
> > On Thu, Dec 25, 2008 at 08:01:29PM +0100, Pavel Machek wrote:
> > > On Mon 2008-12-22 15:11:57, Andrew Patterson wrote:
> > > > ASPM: Use msleep instead of cpu_relax during link retraining
> > > >
> > > > The cpu_relax() function can be a noop on certain architectures
> > > > like IA-64 when CPU threads are disabled, so use msleep instead
> > > > during link retraining busy/wait loop.
> > >
> > > Author clearly wanted to do a busy loop... why do you think 10msec
> > > delay here is acceptable?
> >
> > 10ms?  I see a 1ms sleep.
>
> Yes... IIRC msleep will sleep for up-to 1/HZ on non-highres systems.
>
> > Yes, the subsequent test should be of reg16 instead of jiffies.

Andrew, care to send an updated patch which includes fixes for the issues 
caught by Pavel & Matthew?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

