Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZJ3IQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZJ3IQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 04:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZJ3IQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 04:16:16 -0400
Received: from thunk.org ([69.25.196.29]:43376 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033AbZJ3IQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:16:14 -0400
Date: Fri, 30 Oct 2009 04:16:02 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Message-ID: <20091030081602.GM18464@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Parag Warudkar <parag.lkml@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com> <20091016091558.GA10184@mit.edu> <20091027101534.GA27584@skywalker.linux.vnet.ibm.com> <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com> <4AEA0B71.5050805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEA0B71.5050805@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 04:38:57PM -0500, Eric Sandeen wrote:
>
> I've been running my testcase, and I just hit the usual corruption with  
> this patch in place after 8 iterations, I'm afraid.

Eric, since you have a relatively controllable reproduction case, have
you tried reproducing Alexey's bisection results?  Specifically he
seemed to find that commit fe188c0e shows no problem, and commit
91ac6f43 is the first commit with problems?

Having to do multiple iterations will make doing a bisection a major
pain, but maybe we'll get something out of that.

Other things that might be worth doing given that you have a test case
would be to try reverting commit 91ac6f43, and see if that helps, and
to try this patch: http://bugzilla.kernel.org/attachment.cgi?id=23468

Or have you tried some of these experiments already?

Regards,

						- Ted
