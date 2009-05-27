Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbZE0Lfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbZE0Lfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbZE0Lfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:35:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:46360 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459AbZE0Lfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:35:33 -0400
Message-ID: <4A1D2583.8040803@suse.de>
Date: Wed, 27 May 2009 13:35:31 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
References: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Alan Stern wrote:
> On Wed, 27 May 2009, Kay Sievers wrote:
> 
>> On Wed, May 27, 2009 at 01:49, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>>
>>> OK ... perhaps we have to wait a little harder: try this; it waits until
>>> all the targets have disappeared from visibility via an event.
>> That seems to work fine here.
> 
> It's good for a short-term fix.  For the longer term, I still think 
> it's a mistake to wait for the sdevs to be released before deleting the 
> target.  It gives user programs the ability to block the host-removal 
> thread indefinitely.
> 
Quite so. We should rather see to have the reference counting fixed
properly, than this would go away automatically.

So I just have to look for someone to fix my iSCSI bugs, than I could
revamp my patchset ...

Sigh.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
