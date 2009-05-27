Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbZE0UpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbZE0UpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbZE0UpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:45:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbZE0UpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:45:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bug 13351] 2.6.30 corrupts my system after suspend resume with readonly mounted hard disk
Date: Wed, 27 May 2009 22:45:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: bugzilla-daemon@bugzilla.kernel.org, unggnu@googlemail.com,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <bug-13351-10028@http.bugzilla.kernel.org/> <200905272017.n4RKHN7J004784@demeter.kernel.org>
In-Reply-To: <200905272017.n4RKHN7J004784@demeter.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905272245.03779.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13351
> 
> --- Comment #23 from unggnu@googlemail.com  2009-05-27 20:17:22 ---
> According to bisect it is either 78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742 or
> 6d7942dc2a70a7e74c352107b150265602671588
> The last version doesn't boot so I couldn't nail it down further.
> 
> I have bisect the commits between 2.6.29-rc8 and 2.6.30-rc1 .
> 
> I hope that this helps.

Thanks for bisecting.

We have a serious regression here which appears to have been caused by x86
patches.  Please help!

Best,
Rafael
