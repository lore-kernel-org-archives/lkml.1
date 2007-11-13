Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbXKMHfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbXKMHfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXKMHe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:34:58 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21266 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXKMHe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:34:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JScOppPxLjDLCy3+AgUSjuggE3eBdUe0JUC2DKqrYLjetiyKBp5BE7CRrp6k7ZQ9G
	QbmtIy5lmOSTJ/05ctogA==
Message-ID: <6599ad830711122334h34e7958fh26b71bc4c746eec3@mail.gmail.com>
Date: Mon, 12 Nov 2007 23:34:47 -0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Revert for cgroups CPU accounting subsystem patch
Cc: containers@lists.linux-foundation.org, vatsa@linux.vnet.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <47395277.1060006@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com>
	 <20071113060038.GC3359@linux.vnet.ibm.com>
	 <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
	 <47394B84.8030008@linux.vnet.ibm.com>
	 <6599ad830711122310nf7530cfs5ef1fea061b1252c@mail.gmail.com>
	 <47395277.1060006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 12, 2007 11:29 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> I think it's a good hack, but not sure about the complexity to implement
> the code. I worry that if the number of tasks increase (say run into
> thousands for one or more groups and a few groups have just a few
> tasks), we'll lose out on accuracy.

But for the case we're looking at, you've already said that you don't
care much about actually controlling CPU, just monitoring it. So what
does it matter if the CPU sharing isn't perfectly accurate? I don't
think that you're painting a realistic scenario.

>
> I think we already have the code, we need to make it more useful and
> reusable.

In that case we should take the existing cpu_acct code out of 2.6.24
until the API has been made more useful and reusable, so that we don't
have to support it for ever.

Paul
