Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYGHUHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYGHUHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYGHUHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:07:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36736 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYGHUHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:07:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=R40segMf9daVlVBnRaMhfB76fp4r1zf1VZPHn9anEBqvOMCIiPoSM1vZ1vpKzjSgI
	siD2J/zTBEI3Dmy3uzcGg==
Message-ID: <6599ad830807081307j811689aldf0f6cb38579c450@mail.gmail.com>
Date: Tue, 8 Jul 2008 13:07:09 -0700
From: "Paul Menage" <menage@google.com>
To: "Matt Helsley" <matthltc@us.ibm.com>
Subject: Re: [PATCH 0/4] Container Freezer: Reuse Suspend Freezer
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Cedric Le Goater" <clg@fr.ibm.com>,
       "Linux Containers" <containers@lists.linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
In-Reply-To: <6599ad830807081306l61622eadk215a25d02ee94b00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080707225823.502032693@us.ibm.com>
	 <20080708123150.3034d83f.kamezawa.hiroyu@jp.fujitsu.com>
	 <1215545954.9023.120.camel@localhost.localdomain>
	 <6599ad830807081306l61622eadk215a25d02ee94b00@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2008 at 1:06 PM, Paul Menage <menage@google.com> wrote:
> On Tue, Jul 8, 2008 at 12:39 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
>>
>> One is to try and disallow users from moving frozen tasks. That doesn't
>> seem like a good approach since it would require a new cgroups interface
>> "can_detach()".
>
> Detaching from the old cgroup happens at the same time as attaching to
> the new cgroup, so can_attach() would work here.

And the whole can_attach()/attach() protocol needs reworking anyway,
see my email (hopefully) later today.

Paul
