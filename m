Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZKQP4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZKQP4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZKQP4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:56:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36877 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZKQP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:56:08 -0500
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>
Subject: Re: [PATCH 0/13] sysfs lazification.
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<20091106224857.GB32205@kroah.com> <m1lji5h5xh.fsf@fess.ebiederm.org>
	<20091117154116.GA22756@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Nov 2009 07:56:03 -0800
In-Reply-To: <20091117154116.GA22756@kroah.com> (Greg KH's message of "Tue\, 17 Nov 2009 07\:41\:16 -0800")
Message-ID: <m1hbstf8mk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Tue, Nov 17, 2009 at 01:11:22AM -0800, Eric W. Biederman wrote:
>> Greg KH <greg@kroah.com> writes:
>> 
>> > On Tue, Nov 03, 2009 at 03:53:56AM -0800, Eric W. Biederman wrote:
>> >> 
>> >> The sysfs code updates the vfs caches immediately when the sysfs data
>> >> structures change causing a lot of unnecessary complications.  The
>> >> following patchset untangles that beast.  Allowing for simpler
>> >> more straight forward code, the removal of a hack from the vfs
>> >> to support sysfs, and human comprehensible locking on sysfs.
>> >> 
>> >> Most of these patches have already been reviewed and acked from the
>> >> last time I had time to work on sysfs.
>> >> 
>> >> In net the patches look like:
>> >
>> > Can you resend these based on the review that you just got, with the new
>> > acks and changes so that I can apply them?
>> 
>> Are you going to apply them soon?  If you don't have time I can start
>> a sysfs tree and just ask Linus to pull them.
>
> Well, as the merge window is not open right now, that might be tough to
> get Linus to take them at the moment :)

True. ;)

> I was away last week, and will apply them to my tree this week, thanks
> for your patience.

I'm working on it.

Eric
