Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZDOAHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZDOAHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZDOAHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:07:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43368 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZDOAHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:07:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=UtF5kgkQ5c/XW4/hmuU1iDuFRi8ZfIlUMcO/m13qab6HqZQ2RSOtG/hLsTBGMLl6N
	K3LW4bv1NI7SJLXukvAkA==
MIME-Version: 1.0
In-Reply-To: <1239727023.32604.69.camel@nimitz>
References: <20090410023539.GK27788@x200.localdomain>
	 <20090413214701.GA24509@us.ibm.com> <49E424A3.60606@cs.columbia.edu>
	 <20090414152951.GA7703@us.ibm.com> <1239727023.32604.69.camel@nimitz>
Date: Tue, 14 Apr 2009 17:06:57 -0700
Message-ID: <6599ad830904141706j46d59a00r9f497dd34ec29d9@mail.gmail.com>
Subject: Re: "partial" container checkpoint
From: Paul Menage <menage@google.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
       xemul@parallels.com, containers@lists.linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 9:37 AM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> On Tue, 2009-04-14 at 10:29 -0500, Serge E. Hallyn wrote:
>> I think the perceived need for it comes, as above, from the pure
>> checkpoint-a-whole-container-only view.  So long as you will
>> checkpoint/restore a whole container, then you'll end up doing
>> something requiring privilege anyway.  But that is not all of
>> the use cases.
>
> Yeah, there are certainly a lot of shades of gray here.  I've been
> talking to some HPC guys in the last couple of days.  They certainly
> have a need for checkpoint/restart, but much less of a need for doing
> entire containers.

We'd certainly like the ability to migrate jobs that might be in their
own pid namespace, but not in their own network/IPC/user/etc
namespaces.

Paul
