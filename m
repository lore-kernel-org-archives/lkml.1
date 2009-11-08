Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZKHHGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZKHHGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZKHHGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:06:17 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55536 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZKHHGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:06:17 -0500
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>
Subject: Re: [PATCH 0/13] sysfs lazification.
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<20091106224857.GB32205@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 07 Nov 2009 23:06:15 -0800
In-Reply-To: <20091106224857.GB32205@kroah.com> (Greg KH's message of "Fri\, 6 Nov 2009 14\:48\:57 -0800")
Message-ID: <m1bpjdo5qw.fsf@fess.ebiederm.org>
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

> On Tue, Nov 03, 2009 at 03:53:56AM -0800, Eric W. Biederman wrote:
>> 
>> The sysfs code updates the vfs caches immediately when the sysfs data
>> structures change causing a lot of unnecessary complications.  The
>> following patchset untangles that beast.  Allowing for simpler
>> more straight forward code, the removal of a hack from the vfs
>> to support sysfs, and human comprehensible locking on sysfs.
>> 
>> Most of these patches have already been reviewed and acked from the
>> last time I had time to work on sysfs.
>> 
>> In net the patches look like:
>
> Can you resend these based on the review that you just got, with the new
> acks and changes so that I can apply them?

Coming in just a minute.  The fixes are the trailing patches.

Eric
