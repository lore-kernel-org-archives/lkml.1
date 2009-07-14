Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZGNFcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZGNFcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 01:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZGNFcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 01:32:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:14080 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZGNFcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 01:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=c2xaKpO7rfW5J2X87iSnv2qRTqJndsKwSaTy8nu2EuH9DE0GHf52jzpl3i/2R5uCU9
         VxkB4TTZ6g5uY/tqOVrUuQr+7fbxN2r3N2UE9V7nQa46g3NXdC5nt5To+rW1maEu44el
         uh0skQcvnul6RBOTvNB+cHlPykxNSOj+EKw5I=
Date: Tue, 14 Jul 2009 01:32:02 -0400
From: Celejar <celejar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: suspend to disk now broken
Message-Id: <20090714013202.55c0c575.celejar@gmail.com>
In-Reply-To: <200907140045.52764.rjw@sisk.pl>
References: <20090712151947.25446ceb.celejar@gmail.com>
	<200907130339.35003.rjw@sisk.pl>
	<20090712220721.ff14e2fe.celejar@gmail.com>
	<200907140045.52764.rjw@sisk.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009 00:45:52 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 13 July 2009, Celejar wrote:
> > On Mon, 13 Jul 2009 03:39:34 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Sunday 12 July 2009, Celejar wrote:
> > > > On Sun, 12 Jul 2009 22:56:01 +0200
> > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > 
> > > > > On Sunday 12 July 2009, Celejar wrote:
> > > > > > On Sun, 12 Jul 2009 22:19:52 +0200
> > > > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > > 
> > > > > > > On Sunday 12 July 2009, Celejar wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > A recent change to the kernel has apparently broken suspend to disk on
> > > > > > > > my machine.  It still works fine in 2.6.30.1, but hangs during the
> > > > > > > > 'devices' phase of suspension with 2.6.31-rc2.  [I originally saw the
> > 
> > ...
> > 
> > > Do you use IDE drivers?
> > 
> > Yes.  The system uses IDE/PATA drivers (PIIX).
> 
> If they are of the "old IDE" flavor, there've been some fixes merged recently.
> Please check 2.6.31-rc3 when it's out (or the current mainline).

I built what I think is mainline:

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

and it works.

Thanks!

Celejar
--
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

