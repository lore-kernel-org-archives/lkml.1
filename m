Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZI0Lqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZI0Lqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 07:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZI0Lqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 07:46:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56944 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753823AbZI0Lqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 07:46:34 -0400
Date: Sun, 27 Sep 2009 12:47:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: [Regression] 2.6.31-git: tty change broke resume from
 hibernation on MSI Wind U100
Message-ID: <20090927124716.2fd8a1de@lxorguk.ukuu.org.uk>
In-Reply-To: <200909260038.22079.rjw@sisk.pl>
References: <200909260038.22079.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009 00:38:21 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi Alan,
> 
> As stated at http://bugzilla.kernel.org/show_bug.cgi?id=14229, your commit
> b50989dc444599c8b21edc23536fc305f4e9b7d5
> (tty: make the kref destructor occur asynchronously) appears to have broken
> resume from hibernation on MSI Wind U100.
> 
> I verified that hibernation works correctly with this commit reverted.
> 
> I'm still not sure what the root cause of the problem is, though.

The root cause is that the patch to fix the console async/sync behaviour
went into Andrews tree, back out of it and vanished.

It's a known bug, with a known confirmed fix. You may want to pick it up
and submit it as there is no tty maintainer currently.
