Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYGSBIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYGSBIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYGSBIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:08:10 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:13630 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYGSBII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SbYuMFLU8EUWOLhZ6BEFOIKkEBpZZ+N3quQth0NXcs5UIfrfCq5G7tEkLwtt91Fidh
         g1skGalRBUQTxzRAf8xRfiTIKF4MegV/veSXLXUvkCbwuu23mRj/CgTuGpNkTfATqVpW
         ODpIkFJ8ac4mTrBLgomFBxMByexeuOKQBKhv4=
Message-ID: <48813E6B.30108@gmail.com>
Date: Sat, 19 Jul 2008 10:07:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
 for device classes.
References: <m1mykyh2fu.fsf_-_@frodo.ebiederm.org> <m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com> <m1tzf593ny.fsf@frodo.ebiederm.org> <486E2C3B.6020603@gmail.com> <20080704161200.GA1440@suse.de> <m1lk052ptp.fsf@frodo.ebiederm.org> <487D6A24.9070001@gmail.com> <20080717230857.GB28377@suse.de> <48808F79.7080607@gmail.com> <20080718184936.GA21343@suse.de>
In-Reply-To: <20080718184936.GA21343@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

Greg KH wrote:
> On Fri, Jul 18, 2008 at 09:41:29PM +0900, Tejun Heo wrote:
>> Greg KH wrote:
>>> Ok, I'll work to get these in where applicable.
>> Did this get into 2.6.27?  Or will this have to wait till .28?
> 
> I haven't sent any patches to Linus yet for 2.6.27, so it hasn't gotten
> there yet.
> 
> And due to the intrusiveness, and the fact that this hasn't been tested
> at all in any build tree yet, I can't in good concious submit this for
> .27 either.
> 
> Part of this is my fault, I know, due to vacation and work, but also
> lots is due to the fact that the code showed up so late in the
> development cycle.

Heh... A lot of it is my fault too.  Probably my share is bigger than
anyone else's.  Sorry Eric.

> I'll add it to my tree, and get it some testing in the next cycle of
> linux-next until 2.6.27 is out, and then if it's still looking good, go
> into .28.

I was just curious how the merge will turn out as I'm about to do a
refresh pass on the sysfs locking and stuff.  I'm not sure yet whether
to put those changes on top of or below ns patches but if I'll always
keep the ns patches updated.

Thank you.

-- 
tejun
