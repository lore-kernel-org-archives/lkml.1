Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZBCQz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZBCQz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZBCQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:55:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:16513 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbZBCQzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:55:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=QZV+pXLBladM5P3Vbxs5ovArgVTGwfM+cAeChfJnKLFG9uIX0m4gvjflc8LZ/m5fj
	RW0t/KoG3U+wZI3v1jvIg==
MIME-Version: 1.0
In-Reply-To: <1233671913.8902.53.camel@abacate.horta>
References: <20090202200013.GU3643@vespa.holoscopio.com>
	 <1233606371.15779.32.camel@radis.liafa.jussieu.fr>
	 <20090202205246.GA28593@glandium.org>
	 <20090202214153.GV3643@vespa.holoscopio.com>
	 <20090203102416.GA8886@redhat.com> <87ljsnzo4v.fsf@benfinney.id.au>
	 <1233671913.8902.53.camel@abacate.horta>
Date: Tue, 3 Feb 2009 08:55:34 -0800
Message-ID: <6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>
Subject: Re: cgroup mount point
From: Paul Menage <menage@google.com>
To: Gustavo Noronha <kov@debian.org>
Cc: debian-devel@lists.debian.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.65
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 3, 2009 at 6:38 AM, Gustavo Noronha <kov@debian.org> wrote:
> On Tue, 2009-02-03 at 23:44 +1100, Ben Finney wrote:
>> I agree with all that Thadeu Lima says here. I would add that cgroups
>> are nothing to do with device nodes, so definitely don't belong in
>> '/dev/' either.
>>
>> Since they're a filesystem mapping "for browsing and manipulation
>> from user space" of a kernel facility, I think '/sys/cgroups/' is
>> appropriate.
>
> I agree with this point of view. I believe /sys/cgroups is the way to
> go. Now, of course this has the drawback of shadowing something future
> versions of Linux would make available at that same path, but I am
> pretty sure they would be careful not to do that after distributions
> have settled on a standard path.

Having one virtual filesystem mounted on top of another virtual
filesystem seems like a recipe for problems. /dev/cgroup or
/dev/cgroup/<hierarchy_name> sounds more reasonable to me (although if
anyone is still using devfs that would suffer from the same drawbacks)

Paul
