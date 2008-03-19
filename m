Return-Path: <linux-kernel-owner+w=401wt.eu-S1161433AbYCSWDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161433AbYCSWDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760033AbYCSU1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:27:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2177 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933189AbYCSU1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:27:42 -0400
Date: Wed, 19 Mar 2008 11:01:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Huang, Ying" <ying.huang@intel.com>,
       <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
In-Reply-To: <m1ve3jtmxk.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.44L0.0803191057270.4958-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008, Eric W. Biederman wrote:

> Alan Stern <stern@rowland.harvard.edu> writes:

> > Could it be connected with the way the boot kernel hands control over
> > to the image kernel?  Presumably ACPI isn't prepared to deal with that
> > sort of thing during a boot from S5.  It would have to be fooled into
> > thinking the two kernels were one and the same.
> 
> It should be easy to test if it is a hand over problem, by turning off
> the laptop by placing it in S5 (shutdown -h now) and then booting same
> kernel again.

?  Doesn't this happen every time Rafael turns the computer off and 
then turns it back on?

Do you mean that Rafael should do an S5-type hibernate, but then reboot 
in such a way that the image isn't loaded and resumed?

Alan Stern

