Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbXK0RWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbXK0RWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbXK0RWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:22:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbXK0RWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:22:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: freeze vs freezer
Date: Tue, 27 Nov 2007 18:40:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4744FD87.7010301@goop.org> <200711262253.35420.rjw@sisk.pl> <20071127053846.GA28884@srcf.ucam.org>
In-Reply-To: <20071127053846.GA28884@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271840.24825.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 of November 2007, Matthew Garrett wrote:
> On Mon, Nov 26, 2007 at 10:53:34PM +0100, Rafael J. Wysocki wrote:
> > On Monday, 26 of November 2007, David Chinner wrote:
> > > So how do you handle threads that are blocked on I/O or a lock during
> > > the system freeze process, then?
> > 
> > We wait until they can continue.
> 
> So if I have a process blocked on an unavilable NFS mount, I can't 
> suspend?

That's correct, you can't.

[And I know what you're going to say. ;-)]

Greetings,
Rafael
