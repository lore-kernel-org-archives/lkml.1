Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYLaUPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYLaUPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 15:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYLaUO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 15:14:58 -0500
Received: from outbound-mail-317.bluehost.com ([67.222.54.10]:41007 "HELO
	outbound-mail-317.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751784AbYLaUO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 15:14:58 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2008 15:14:58 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=R33Y7RbRLS22dh06kvrXRwbGXj29ncpoT/Fw/LZEZXHdppP7F11vKwoJNOS1kixBn4F7OAsNns4/Q3U0JRbeF7Z8vkOu+sX3E50jd4NVQ2AtKW7IVmPqKs72Xs0/j92G;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] work_on_cpu: use in drivers/pci/pci-driver.c
Date: Wed, 31 Dec 2008 12:08:16 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <200812011850.42203.rusty@rustcorp.com.au> <200812091452.48824.jbarnes@virtuousgeek.org> <200812312354.56454.rusty@rustcorp.com.au>
In-Reply-To: <200812312354.56454.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812311208.16866.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 31, 2008 5:24 am Rusty Russell wrote:
> On Wednesday 10 December 2008 09:22:48 Jesse Barnes wrote:
> > On Monday, December 01, 2008 12:20 am Rusty Russell wrote:
> > > This uses work_on_cpu(), rather than altering the cpumask of the
> > > thread which we happen to be.
> >
> > Nice, I applied this to my linux-next branch to get some build/test
> > coverage. Please cc linux-pci in the future though.
>
> Hi Jesse,
>
>    I don't see this in linux-next, nor Linus' tree.  Here it is again...

Thanks for following up, not sure how I lost it (must have been dropped in a 
tangle of other patches or something).  It's pushed for real now...

Thanks,
Jesse
