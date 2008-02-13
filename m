Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbYBMWhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbYBMWhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYBMWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:37:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44127 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYBMWhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:37:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: udf regression: broken directory handling
Date: Wed, 13 Feb 2008 23:36:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20080210104754.GH6737@joi> <20080212113916.GA13425@duck.suse.cz> <20080212182638.GA8334@joi>
In-Reply-To: <20080212182638.GA8334@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132336.05560.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of February 2008, Marcin Slusarz wrote:
> On Tue, Feb 12, 2008 at 12:39:17PM +0100, Jan Kara wrote:
> > On Mon 11-02-08 20:13:20, Marcin Slusarz wrote:
> > > On Mon, Feb 11, 2008 at 12:09:10PM +0100, Jan Kara wrote:
> > > >   Hi,
> > > > 
> > > > On Sun 10-02-08 11:48:17, Marcin Slusarz wrote:
> > > > > Current mainline has a problem with reading file list.
> > > > > Simple ls prints only 2 out of 8 files on my testing DVD.
> > > > > Reverting your patch "udf: cleanup directory offset handling"
> > > > > (af793295bf9ee92660f5e77d337b0493cea3f9b9) fixes the problem.
> > > >   Thanks for testing! Do you have a way to create such UDF filesystem? For
> > > > the filesystems I've created it seems to work just fine...
> > > 
> > > with patch applied:
> >   <snip testing>
> > 
> >   Argh, I've submitted an old version of the patch missing changes in
> > dir.c. Below is the missing hunk. Does UDF work for you with it?
> Yes.

Has the issue been fixed in the mainline?

Rafael
