Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYJUSji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYJUSji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYJUSja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:39:30 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:62640 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYJUSj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:39:29 -0400
X-IronPort-AV: E=Sophos;i="4.33,459,1220227200"; 
   d="scan'208";a="179838764"
From: Roland Dreier <rdreier@cisco.com>
To: "Dan Upton" <upton.dan.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: debugging an oops that kills the system
References: <ba7d8f720810211014g472c3e83oba511c24e1c2eb97@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 21 Oct 2008 11:39:27 -0700
In-Reply-To: <ba7d8f720810211014g472c3e83oba511c24e1c2eb97@mail.gmail.com>
	(Dan Upton's message of "Tue, 21 Oct 2008 13:14:02 -0400")
Message-ID: <adar669okrk.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Oct 2008 18:39:28.0196 (UTC) FILETIME=[59469840:01C933AC]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'm hoping for some pointers on debugging an oops that ultimately
 > hangs the system.  I'm doing some scheduler work and I can fairly
 > reliably duplicate the error on my machine, but the output is too
 > large for one screen and the system becomes unresponsive after the
 > crash so I can't scroll the console.  I tried purchasing a  USB->DB9
 > cable to log to a remote terminal, but so far I haven't had any luck
 > getting that to work.  Using kdump/kexec doesn't work either--I got
 > the second kernel to boot successfully using the magic sysrq example
 > in the documentation, but the second kernel doesn't boot with my
 > actual crash.  Any other suggestions for what I might do?

If you have two machines (it sounds like you do) and serial console is
not working for you (could be a setup problem -- do you have a
"console=" line on your kernel command line?), then netconsole might be
a good way to debug: Documentation/networking/netconsole.txt

 - R.
