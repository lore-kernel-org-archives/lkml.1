Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbZBKQwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbZBKQwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZBKQwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:52:22 -0500
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:42019 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754595AbZBKQwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:52:21 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] auxdisplay: remove PARPORT dependency
Date: Wed, 11 Feb 2009 11:51:59 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090120C583@mi8nycmail19.Mi8.com>
In-Reply-To: <ca2dc2820902110237u7c050e98t29019cc89d66a6a3@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] auxdisplay: remove PARPORT dependency
Thread-Index: AcmMNMTdEt0/pT4BQxurrmKFRnZopQAMlGwg
References: <BD79186B4FD85F4B8E60E381CAEE19090120BD69@mi8nycmail19.Mi8.com> <20090209143716.57467016.akpm@linux-foundation.org> <BD79186B4FD85F4B8E60E381CAEE19090120C0B8@mi8nycmail19.Mi8.com> <ca2dc2820902110237u7c050e98t29019cc89d66a6a3@mail.gmail.com>
From: "hartleys" <hartleys@visionengravers.com>
To: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Feb 2009 16:52:16.0761 (UTC) FILETIME=[18853E90:01C98C69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 11, 2009 3:38 AM, Miguel Ojeda wrote:
>> I think the dependency will be handled automatically.  Both
>> cfag12864b.c and cfag12864bfb.c are enabled by CFAG12864B which
>> has a dependency on KS0108, which it turn depends on PARPORT_PC.
>
> That's true; however, I think it is intentional: cfag12864bfb
> depends on cfags12864b, and this one depends on ks0108, which
> depends on parport and, for the moment, there aren't more entries
> on "Auxiliary Display support". Thereafter, if PARPORT is not
> selected, the user is not bothered with an additional menu entry
> on "Device Drivers".
>
> I don't know which is the trend nowadays in this subject (i.e. to
> show every menu althought empty or not). I see Andrew has already
> added the patch, so I bet on his decision ;)

The arm branch Kconfig was updated awhile back to include auxdisplay.

I have been messing with a couple LCD devices similar to the cfag12864.
Every time I update my kernel source I have needed to add this patch
since my arm platform does not have PARPORT_PC.

That was my stimulus for the patch.  It does cause the empty menu to
appear but some others already do that so I didn't think it was a
problem.

Regards,
Hartley
