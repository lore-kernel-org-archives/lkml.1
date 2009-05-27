Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbZE0CRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbZE0CRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbZE0CRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:17:42 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59168 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751147AbZE0CRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:17:42 -0400
Date: Tue, 26 May 2009 22:17:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
In-Reply-To: <ac3eb2510905261702n44c785a0hd0e59b5deb0fe903@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Kay Sievers wrote:

> On Wed, May 27, 2009 at 01:49, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> 
> > OK ... perhaps we have to wait a little harder: try this; it waits until
> > all the targets have disappeared from visibility via an event.
> 
> That seems to work fine here.

It's good for a short-term fix.  For the longer term, I still think 
it's a mistake to wait for the sdevs to be released before deleting the 
target.  It gives user programs the ability to block the host-removal 
thread indefinitely.

Alan Stern

