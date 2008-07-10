Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbYGJRbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbYGJRbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbYGJRa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:30:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41095 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760344AbYGJRaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:30:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Ru3d2HYLujIvjUxJhuStzYUayqSUxwVz6CAXihPlRGaBs0wRc6/3ZHBkbWpD9vL5Z
	B9qdsoKjHLONSbVBuOTUg==
Message-ID: <6599ad830807101030i2f3a15a3l3409a36c11773f25@mail.gmail.com>
Date: Thu, 10 Jul 2008 10:30:15 -0700
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [Libcg-devel] [RFC] How to handle the rules engine for cgroups
Cc: "Vivek Goyal" <vgoyal@redhat.com>, "Peter Zijlstra" <pzijlstr@redhat.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Libcg Devel Mailing List" <libcg-devel@lists.sourceforge.net>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20080710171838.GA4235@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701191126.GA17376@redhat.com>
	 <6599ad830807100207q26cf2416qb8d38d1d715b5ba0@mail.gmail.com>
	 <20080710143307.GD3782@redhat.com>
	 <6599ad830807100946j6db8d0d6se18f1b428c69ad5c@mail.gmail.com>
	 <20080710171838.GA4235@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 10:18 AM, Dhaval Giani
<dhaval@linux.vnet.ibm.com> wrote:
>
> I am sorry, I seem to missing something, but who moves the forked
> children (which got forked during the time between the parent getting
> classified into the right group and the fork itself) into the correct
> group?

The classifier daemon would have to do that - my point was that it
would be very clear exactly which processes needed this attention,
since they'd end up in the root cgroup too.

Paul
