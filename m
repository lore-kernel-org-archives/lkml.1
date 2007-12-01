Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbXLALgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbXLALgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 06:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXLALgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 06:36:22 -0500
Received: from bongo.filmlight.ltd.uk ([217.40.27.26]:4487 "HELO
	b.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751465AbXLALgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 06:36:21 -0500
Message-ID: <01bf01c8340e$63e90060$6501a8c0@BODDINGTON>
From: "Roger Willcocks" <roger@filmlight.ltd.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-kernel@vger.kernel.org>, <nfs@lists.sourceforge.net>,
       "Neil Brown" <neilb@suse.de>
References: <475042FB.8020106@filmlight.ltd.uk> <20071130220127.GJ24887@fieldses.org>
Subject: Re: nfsd bug: create file with specific uid/gid
Date: Sat, 1 Dec 2007 11:36:18 -0000
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:

> On Fri, Nov 30, 2007 at 05:06:03PM +0000, Roger Willcocks wrote:
>> nfsd/vfs.c:nfsd_create (the v2 version of create) says:
>>
>> "Set file attributes. Mode has already been set and
>> setting uid/gid works only for root"
>>
>> but it doesn't actually test for root-ness
...
> Assignments (especially with things like &=) inside of conditionals
> always make my head hurt for some reason.  So maybe something like the
> below?

The patch looks fine to me, note that nfsd_create_v3 needs fixing too.

>
> Thanks for the bug report!  (And, by the way, how did you run across
> this?)
>

I'm working on an NFSp-like server for our clustered file system and my data 
file creates were not working as expected.

--
Roger

