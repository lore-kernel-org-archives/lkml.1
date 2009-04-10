Return-Path: <linux-kernel-owner+w=401wt.eu-S936533AbZDJMsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936533AbZDJMsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761907AbZDJMsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:48:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44352 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762666AbZDJMsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:48:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
Date: Fri, 10 Apr 2009 14:48:37 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org>
In-Reply-To: <E1Ls9pZ-0004IF-FZ@closure.thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904101448.38166.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 April 2009, Theodore Ts'o wrote:
> Hi, has anyone else noticed that suspend-to-ram seems to have gotten
> broken in 2.6.30-rc1, sometime during last half of the merge window?
> I've been at a conference all of this past week, so I haven't had time
> to bisect it yet.  I was wondering if anyone else had noticed and
> figured out what was going wrong.  Symptoms are that the suspend "moon"
> starts flashing and the system never manages to put itself to sleep.  

There was one similar report, but that issue should be fixed in 2.6.30-rc1
if I remember correctly.

Can you test commit 0a0c5168df270a50e3518e4f12bddb31f8f5f38f
(PM: Introduce functions for suspending and resuming device interrupts), plaese?

Rafael
