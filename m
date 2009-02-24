Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbZBXRFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbZBXRFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZBXRFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:05:20 -0500
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:38230 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758427AbZBXRFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:05:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=V3Ifo4AdemSuOAqhCX/1P7XD1mPikD++30Ort1hPC6uNsvFZnX06Sc8PGxYzhbv3gIHLg2mwVO1hZsGIWYpeD/io7nGxNv8qMuLo5HQaibMZ7UBx6Fq1/aPZrRe1XGZO;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
Date: Tue, 24 Feb 2009 09:05:09 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <m1pri623g9.fsf@fess.ebiederm.org> <499BA141.2090403@jp.fujitsu.com> <m1vdr15s1v.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdr15s1v.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240905.09964.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 23, 2009 3:08:44 am Eric W. Biederman wrote:
> Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> writes:
> > Ok, I understood what is happening. Could you try the following patch?
> > It is currently in Jesse's linux-next.
> >
> > http://marc.info/?l=linux-pci&m=123364118418484&w=2
> >
> > BTW, I don't think surprise removal is well tested.
>
> That patch should guarantee that we don't loop forever, and if we are
> going to loop that looks like a reasonable way to handle it.
>
> When I start working on what is the most maintainable way to implement
> merge my hotplug driver work I will come back and test this.
>
> At the moment it appears that it will at least suffer from detecting a
> presence change event with a device showing up.  Before pci structure
> for the device is removed.  I seem to recall some dead locks on the
> pciehp work queue hotunplugging a hotplug driver as well.

So where does that leave us with your original patch; do you think we need 
something in 2.6.29 for this issue?  Or are you planning on reworking things 
for .30?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
