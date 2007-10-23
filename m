Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbXJWHxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbXJWHxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXJWHxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:53:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:19736 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbXJWHxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:53:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=eIynjf3FwzfTUhNfe1g3FY/kQicrzjAub0Sr0nQNo+PKrm0Oh/JCIs4iHEEFBY7Vm
	PJRy2OgZuckeV4yCihLKQ==
Message-ID: <6599ad830710230053l35fffaf5ld8882eaae8b9df7c@mail.gmail.com>
Date: Tue, 23 Oct 2007 00:53:16 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Cc: vatsa@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <471DA78F.4090600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4523.4040509@google.com>
	 <20071023024036.GC3324@linux.vnet.ibm.com>
	 <6599ad830710222306m6a3e3f52k4daf501836c05274@mail.gmail.com>
	 <6599ad830710230021n536908c0xd95250f36aa8a27d@mail.gmail.com>
	 <471DA78F.4090600@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> Well, most people who care about deletion will use the notify_on_release
> callback and retry.

I'm not convinced this is true. Certainly the userspace approaches
we're developing at Google don't (currently) use notify_on_release.

Paul
