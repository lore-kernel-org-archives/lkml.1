Return-Path: <linux-kernel-owner+w=401wt.eu-S1161469AbXDWTVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161469AbXDWTVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161482AbXDWTVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:21:15 -0400
Received: from gw.goop.org ([64.81.55.164]:40746 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161469AbXDWTVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:21:14 -0400
Message-ID: <462D072F.6030809@goop.org>
Date: Mon, 23 Apr 2007 12:21:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org>	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>	<m1d51vxxm4.fsf@ebiederm.dsl.xmission.com> <462CE027.4030302@goop.org>	<462CE1E0.9060007@zytor.com>	<m1zm4zvwfr.fsf@ebiederm.dsl.xmission.com>	<462CF5B8.4070708@xensource.com> <m1y7kivs3s.fsf@ebiederm.dsl.xmission.com> <462D04B2.6080008@goop.org> <462D05A0.1020100@zytor.com>
In-Reply-To: <462D05A0.1020100@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> It would be *trivial* to make a certain number of page table slots
> available at the end of the head.S-generated map. 

Or you could use a fixmap.

    J
