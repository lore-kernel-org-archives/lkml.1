Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbYAFWWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbYAFWWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbYAFWWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:22:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758189AbYAFWWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:22:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
Date: Sun, 6 Jan 2008 23:24:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0801061710140.19222-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801061710140.19222-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801062324.15960.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of January 2008, Alan Stern wrote:
> On Sun, 6 Jan 2008, Rafael J. Wysocki wrote:
> 
> > On Sunday, 6 of January 2008, Alan Stern wrote:
> 
> > Still, shouldn't we fail the removal of the device apart from giving the
> > warning?
> 
> We can't.  device_del() can't fail -- it returns void.  Besides, how 
> can a driver hope to deal with an unregistration failure?

Well, right.

Still, our present approach doesn't seem to be correct overall.  For example,
I think we should prevent a suspend from happening while a device is being
removed.

Rafael
