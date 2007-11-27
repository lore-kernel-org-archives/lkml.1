Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbXK0Fjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbXK0Fjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbXK0Fj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:39:26 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:39071 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbXK0FjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:39:25 -0500
Date: Tue, 27 Nov 2007 05:38:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20071127053846.GA28884@srcf.ucam.org>
References: <4744FD87.7010301@goop.org> <200711240047.21624.rjw@sisk.pl> <20071126211705.GC119954183@sgi.com> <200711262253.35420.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711262253.35420.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: freeze vs freezer
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 10:53:34PM +0100, Rafael J. Wysocki wrote:
> On Monday, 26 of November 2007, David Chinner wrote:
> > So how do you handle threads that are blocked on I/O or a lock during
> > the system freeze process, then?
> 
> We wait until they can continue.

So if I have a process blocked on an unavilable NFS mount, I can't 
suspend?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
