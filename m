Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbXGXQyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbXGXQyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXGXQyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:54:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48087 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751860AbXGXQym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:54:42 -0400
Date: Tue, 24 Jul 2007 18:54:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@suspend2.net,
       linux-kernel@vger.kernel.org
Subject: Re: which signal is sent to freeze process?
Message-ID: <20070724165452.GA24151@elf.ucw.cz>
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707210010.05877.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD62858D512@scsmsx412.amr.corp.intel.com> <200707232125.09070.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD62858D5AE@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD62858D5AE@scsmsx412.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Can you generate small testcase that demonstrates the problem?

> Then what would be the correct way to handle resume process. The other
> way of course is to make all the applications check the errno in case of
> failure. But that seems more more problematic then system call checking.
> What do you say?

Hmm, does that testcase behave correctly over SIGSTOP/SIGCONT? I'm not
saying kernel behaves nicely here, but perhaps fixing the apps to
check errno properly is the right thing to do? :-)
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
