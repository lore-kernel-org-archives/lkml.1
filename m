Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbZBZOc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbZBZOc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762812AbZBZObo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:31:44 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:59944 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093AbZBZObn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:31:43 -0500
MIME-Version: 1.0
In-Reply-To: <20090224141548.GB5482@mit.edu>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl>
	 <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org>
	 <49A3AC14.2050107@slax.org> <20090224141548.GB5482@mit.edu>
Date: Thu, 26 Feb 2009 16:31:39 +0200
Message-ID: <37786d4b0902260631r4916b5a8h93700257d882c233@mail.gmail.com>
Subject: Re: New filesystem for Linux kernel
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Theodore Tso <tytso@mit.edu>, Tomas M <tomas@slax.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 4:15 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Feb 24, 2009 at 09:13:08AM +0100, Tomas M wrote:
>> An overview of aufs2 has been submitted to this list.
>> I noticed zero response at all. Nobody cares?
>>
>> I suggest to remove unionfs from Andrew's -mm tree and replace it by aufs2!
>> Tell me why this should not happen...
>
> Um, you need to tell us why aufs2 is better than Unionfs.  The burden
> of proof rests on your shoulders.  The code which is displacing
> existing code needs to give a justification about why it is better
> than the code which is displacing, not the other way around.

Does it really have to displace unionfs? Why can't it be merged in
(after proper review) alongside unionfs?

Ubuntu moved to aufs for some of the same reasons that Tomas has
outlined elsewhere in this thread. Unionfs required some hand holding
everytime we upgraded to a new kernel while aufs has not given us
those problems. And yes, unionfs races have given us several sleepless
nights before releases.

Regards,
Amit (with Ubuntu Kernel Developer hat on)
