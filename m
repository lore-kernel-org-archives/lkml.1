Return-Path: <linux-kernel-owner+w=401wt.eu-S941689AbYCSWw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941689AbYCSWw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbYCSVUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:20:21 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2249 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1765596AbYCSVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:20:14 -0400
Date: Tue, 18 Mar 2008 22:33:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>, <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
In-Reply-To: <200803190108.05004.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803182228520.10154-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Rafael J. Wysocki wrote:

> Well, I've been saying that for I-don't-remember-how-long: on my box, if you
> use S5 instead of entering S4, the fan doesn't work correctly after the
> resume.  Plain and simple.
> 
> Perhaps there's a problem with our ACPI drivers that causes this to happen,
> but I have no idea what that can be at the moment.

IMO it would be worthwhile to track this down.  It's a clear indication 
that something is wrong somewhere.

Could it be connected with the way the boot kernel hands control over
to the image kernel?  Presumably ACPI isn't prepared to deal with that
sort of thing during a boot from S5.  It would have to be fooled into
thinking the two kernels were one and the same.

Alan Stern

