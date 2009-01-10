Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZAJWsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZAJWsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZAJWse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:48:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46231 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZAJWse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:48:34 -0500
Date: Sat, 10 Jan 2009 23:46:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Scott James Remnant <scott@canonical.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090110224616.GA29046@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107171922.GA18000@redhat.com> <1231598863.11642.55.camel@quest> <49690FC9.4010403@redhat.com> <20090110223130.GA28581@redhat.com> <4969230F.4080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4969230F.4080609@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Casey Dahlin wrote:
>
> Oleg Nesterov wrote:
>>> From the perspective of waitfd, the only difference between WNOHANG and
>>> O_NONBLOCK is which argument you put the flags in.
>>
>> No. Please see the note about ioctl/fcntl above.
>>
>> Oleg.
>>
> Yes but the actual waitfd call could simply set O_NONBLOCK on the
> descriptor when it receive WNOHANG in the flags, and read the descriptor
> flags going forward.

Ah, I misunderstood your message as if we shouldn't check f_flags at all.

Yes sure.

Oleg.

