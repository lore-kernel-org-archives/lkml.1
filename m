Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691Ab0AMR5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0AMR5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607Ab0AMR5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:57:36 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36820 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab0AMR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:57:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=p/z4vvLhN5CJ7d9tYohiHw1gmsdWNSKeGkaK8dbMjQQoDeUv9cfnO4oPTFjLYovn+g
         /C3NGOvFYmTPSZoXojk7jltGNR/hbYFiGHpQz3yOjzdtp7+hh3Ho/PJfa5sZQrgUmxl8
         qL/rUrB9S0e59JQ4B18zYvRI9z3oFn2WI4txo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Changelog quality
Date: Wed, 13 Jan 2010 18:49:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Julia Lawall <julia@diku.dk>,
       =?iso-8859-1?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
References: <Pine.LNX.4.44L0.1001131225160.3518-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001131225160.3518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001131849.42328.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010 06:29:07 pm Alan Stern wrote:
> On Wed, 13 Jan 2010, Stefan Richter wrote:
> 
> > If it was by mistake, inclusion of the find-and-replace script into the
> > patch posting *after the --- delimiter* might have increased the chance
> > that a patch reviewer becomes aware of a possible error source
> > (inadequate match patterns...).  So that could be useful during review
> > before commit, but not so much if the change is revisited some time
> > after commit.
> 
> Somewhat tangentially, it's worth mentioning that the comments
> appearing after the "---" delimiter exist only in the original patch
> submissions, not in the final commits.  Hence they are not available to
> anyone reviewing the changes after acceptance.
> 
> It would be nice if there was a way to link automatically a git commit
> to an archived copy of the email message in which it was originally 
> submitted.

AFAIK x86 folks are using "LKML-Reference:" tag with the message ID for
exactly that purpose (just do 'git log arch/x86' to find such commits).

BTW Personally I see nothing wrong with too verbose commit changelogs,
too sparse changelogs are a much bigger annoyance..

--
Bartlomiej Zolnierkiewicz
