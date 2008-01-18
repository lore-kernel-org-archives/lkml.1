Return-Path: <linux-kernel-owner+w=401wt.eu-S1763540AbYARRoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763540AbYARRoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760724AbYARRny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:43:54 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56913 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760160AbYARRnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:43:53 -0500
In-Reply-To: <4790C0EE.10207@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Daniel Phillips <phillips@google.com>,
       Ric Wheeler <ric@emc.com>, Rik van Riel <riel@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Valerie Henson <val.henson@gmail.com>
MIME-Version: 1.0
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFC2B46E42.BDE3F6A4-ON882573D4.0060B268-882573D4.00615C9C@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Fri, 18 Jan 2008 09:43:25 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0|August 02, 2007) at 01/18/2008
 12:43:26,
	Serialize complete at 01/18/2008 12:43:26
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> wrote on 01/18/2008 07:08:30 AM:

> Bryan Henderson wrote:
> > 
> > We weren't actually talking about writing out the cache.  While that 
was 
> > part of an earlier thread which ultimately conceded that disk drives 
most 
> > probably do not use the spinning disk energy to write out the cache, 
the 
> > claim was then made that the drive at least survives long enough to 
finish 
> > writing the sector it was writing, thereby maintaining the integrity 
of 
> > the data at the drive level.  People often say that a disk drive 
> > guarantees atomic writes at the sector level even in the face of a 
power 
> > failure.
> > 
> > But I heard some years ago from a disk drive engineer that that is a 
myth 
> > just like the rotational energy thing.  I added that to the 
discussion, 
> > but admitted that I haven't actually seen a disk drive write a partial 

> > sector.
> > 
> 
> A disk drive whose power is cut needs to have enough residual power to 
> park its heads (or *massive* data loss will occur), and at that point it 

> might as well keep enough on hand to finish an in-progress sector write.
> 
> There are two possible sources of onboard temporary power: a large 
> enough capacitor, or the rotational energy of the platters (an 
> electrical motor also being a generator.)  I don't care which one they 
> use, but they need to do something.

I believe the power for that comes from a third source: a spring.  Parking 
the heads is too important to leave to active circuits.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

