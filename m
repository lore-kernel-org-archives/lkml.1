Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYKUEmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYKUEmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 23:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYKUEmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 23:42:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:9024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbYKUEme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 23:42:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=oOBwfb1U8KLrCBQ61rBVZHv8KHsOM5UbINQxheXHcyNmD3E7rVm0mzKRYswFJy7Zd
	JiIo5zbCGrB37FtaN4b/A==
MIME-Version: 1.0
In-Reply-To: <1226962063.3403.13.camel@localhost.localdomain>
References: <1226962063.3403.13.camel@localhost.localdomain>
Date: Thu, 20 Nov 2008 20:42:29 -0800
Message-ID: <da824cf30811202042p43549a1bne0eefa627424be33@mail.gmail.com>
Subject: Re: Enterprise workload testing for storage and filesystems
From: Grant Grundler <grundler@google.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 2:47 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Hi all,
>
> High on our list at the recent Linux Foundation end user summit was
> obtaining a method of obtaining enterprise workloads (or simulators) we
> can run in our own testing environments.  The main problem being that
> the data sets used by the systems are usually secret or under regulatory
> embargo and thus unobtainable.  However, several participants noted that
> regulatory prohibitions also extended to their own in-house IT team,
> thus they had had to develop simulators for the workloads which, since
> they contained no customer data, might be more widely distributable.

Google has the same concerns. Hoping to work through those, last year
I arranged funding for UNSW (Joshua Root) to develop a GPL linux block
layer replay tool:
    http://www.gelato.unsw.edu.au/IA64wiki/JoshuaRoot/MarkovChains

Unfortunately, I've not been able to address all concerns with this
and thus can't offer any google specific markov chains. :( Still I
hope this tool can be of use to others.


> Fidelity National Information Service were the first to try this.
> They've kicked off a sourceforge site for their stress testing tool
> (which is the same tool they use in their own qualification labs).  The
> source for the tool is available here:
>
> http://sourceforge.net/project/showfiles.php?group_id=11026&package_id=298597

Awesome! Kudos!

> And it comes with a fairly detailed readme explaining what it's trying
> to simulate and why.  Hopefully this will give us all a much better
> insight into both enterprise workloads and the way enterprise IT
> departments conduct testing.
>
> Let's see how our storage and filesystem tuning measures up to this.

*nod*

thanks,
grant
