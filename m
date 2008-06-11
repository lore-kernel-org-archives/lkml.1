Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbYFKSKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbYFKSKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932385AbYFKSKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:10:33 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:50919 "EHLO
	mail176-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbYFKSKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:10:31 -0400
X-BigFish: VPS-39(z6f5iz542N154dM98dR7efVzzzz1157Pz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K2B94N-03-0LL-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver: Setup routines
Date: Wed, 11 Jun 2008 14:10:00 -0400
Message-ID: <6096959DEF5C9447A6BF80BDC7EB9EDC08650A6C@SBOSEXMB1.amd.com>
In-Reply-To: <20080611180104.GA4072@ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver: Setup routines
Thread-Index: AcjL7TDLEnvmp2IhQba3GJPXF8EegwAAFJeA
References: <87abhsp42o.fsf@basil.nowhere.org> <6096959DEF5C9447A6BF80BDC7EB9EDC08650A67@SBOSEXMB1.amd.com> <20080611180104.GA4072@ucw.cz>
From: "Kasindorf, Barry" <Barry.Kasindorf@amd.com>
To: "Pavel Machek" <pavel@suse.cz>
Cc: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Jun 2008 18:10:04.0719 (UTC) FILETIME=[5FA25BF0:01C8CBEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a thorny problem.
A mistake was made in the name almost 2 years ago. The longer we leave
it wrong the harder it will be to change. To use IBS, the major feature
added by this patch, you HAVE to upgrade the user tools anyway. If there
was a way to have the driver send both I would have done that. So far it
is a very narrow window of time that would have a problem.

If I get too much pushback I can leave it, but the code that sends
Family10 has not been present in the kernel for very long at this point,
and it should be fixed. When the patch that added Family10 went in it
had the same issue, before it would have reported Family8 and worked
with the older userspace tools, adding this would get a cpu type unset
error.

-Barry


-----Original Message-----
From: Pavel Machek [mailto:pavel@suse.cz] 
Sent: Wednesday, June 11, 2008 2:01 PM
To: Kasindorf, Barry
Cc: Andi Kleen; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver:
Setup routines

On Wed 2008-06-11 09:29:29, Kasindorf, Barry wrote:
> Yes,
> This is visible to userspace. The corresponding changes to the
usermode
> code have been sent to the oProfile list. The confusion is that it is
> not AMD Family 10 but it is Family 16(10h). This can be confusing so
we
> changed it.

...so we require users to upgrade userspace tools at the same moment
they upgrade kernel, and they can't go to the old kernel. Bad.

(Please mention userspace change in changelog).

I don't think potential for confusion is that big... and perhaps you
can do s/10/10h/ in userspace tools?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


