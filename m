Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbYAQVh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbYAQVh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYAQVhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:37:13 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41614 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbYAQVhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:37:11 -0500
In-Reply-To: <4d47a5d10801161802x2c24ef59pf8422c8d14d487aa@mail.gmail.com>
To: "Daniel Phillips" <phillips@google.com>
Cc: "Al Boldi" <a1426z@gawab.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Chinner" <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Rik van Riel" <riel@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Valerie Henson" <val.henson@gmail.com>
MIME-Version: 1.0
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFD3904E7A.3DEFF08C-ON882573D3.0062286D-882573D3.0076C09B@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Thu, 17 Jan 2008 13:37:04 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0|August 02, 2007) at 01/17/2008
 16:37:05,
	Serialize complete at 01/17/2008 16:37:05
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel Phillips" <phillips@google.com> wrote on 01/16/2008 06:02:50 PM:

> On Jan 16, 2008 2:06 PM, Bryan Henderson <hbryan@us.ibm.com> wrote:
> > >The "disk motor as a generator" tale may not be purely folklore. When
> > >an IDE drive is not in writeback mode, something special needs to 
done
> > >to ensure the last write to media is not a scribble.
> >
> > No it doesn't.  The last write _is_ a scribble.
> 
> Have you observed that in the wild?  A former engineer of a disk drive
> company suggests to me that the capacitors on the board provide enough
> power to complete the last sector, even to park the head.

No, I haven't.  It's hearsay, and from about 3 years ago.

As for parking the head, that's hard to believe, since it's so easy and 
more reliable to use a spring and an electromagnet.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

