Return-Path: <linux-kernel-owner+w=401wt.eu-S934182AbZFLVuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182AbZFLVuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762091AbZFLVuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:50:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58450 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153AbZFLVuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:50:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding:x-system-of-record;
	b=tXcSws05brFKXxj6bnQ3TF+VcsjCis1ieHjU4DngP83Tb/oJP1How7pnFHKC7LSQW
	yzlw3Tw7PbgRQsioNcO/A==
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 14:50:21 -0700
Message-ID: <a55d774e0906121450x12bab7b0sc1f4de0115a1af61@mail.gmail.com>
Subject: Gerrit (was Re: HTC Dream aka. t-mobile g1 support)
From: Brian Swetland <swetland@google.com>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, sop@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 10:35 AM, Stefan
Schmidt<stefan@datenfreihafen.org> wrote:
>> I think the intent is to have a
>> Gerrit instance to accept contributions.  I'll have to look into
>> whether this can be done without signing the agreement.  Right
>> now, I can't even contribute anything, so there are a lot of
>> issues to work out.
>
> Gerrit is the Android review system? I'm only interested into the kernel and
> especially running a mainline kernel on different devices. Anyway, a public
> review process and some more informations on what you are working and how you
> would like to bring it mainline would help here.

Gerrit is a git patch review system that we (Google/Android) use for
android development (kernel and otherwise).  Some other folks like
Qualcomm, and TI (see http://review.omapzoom.org/) have adopted it as
well.  We're still happy to accept patches via email and
review/discuss them on the usual mailing lists as well.  It'd be cool
to get an automated process set up to slurp submitted patches into
Gerrit at some point, and further unify the two different workflows.

Gerrit's very actively maintained by Shawn O. Pearce:
http://code.google.com/p/gerrit/

Here's an example of a patch in Gerrit (though a dull one -- when
logged in you can basically annotate the diff with line by line
comments, etc, which is pretty slick if you like that sort of thing):
https://review.source.android.com/10348

Brian
