Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYHLV5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYHLV5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYHLV5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:57:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbYHLV5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:57:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>, zajec5@gmail.com
Subject: Re: [Bugme-new] [Bug 11313] New: Plugging HDMI causes "unable to handle kernel paging request"
Date: Tue, 12 Aug 2008 23:59:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
References: <bug-11313-10286@http.bugzilla.kernel.org/> <20080812144406.0c8aff48.akpm@linux-foundation.org>
In-Reply-To: <20080812144406.0c8aff48.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808122359.58924.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Andrew Morton wrote:
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Tue, 12 Aug 2008 14:30:01 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11313
> > 
> >            Summary: Plugging HDMI causes "unable to handle kernel paging
> >                     request"
> >            Product: Platform Specific/Hardware
> >            Version: 2.5
> >      KernelVersion: 2.6.27-rcX
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: high
> >           Priority: P1
> >          Component: x86-64
> >         AssignedTo: platform_x86_64@kernel-bugs.osdl.org
> >         ReportedBy: zajec5@gmail.com
> >
> > Latest working kernel version: 2.6.26
> 
> ugh.  Random rampant memory corruption caused by unplugging an HDMI
> cable?  I'm not even sure which subsystem could be involved here.

Hm.  Isn't that X trying to access memory which is not mapped?

Rafa³, which graphics driver are you using?
