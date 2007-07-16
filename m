Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXGPIiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXGPIiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbXGPIir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:38:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:23932 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbXGPIiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DqMb4sOSHXnl9NlPfZjYZL4EF0pACLq84TH9b0AXyygb5dfAhPXl+mdpWOp+KUcE+xPGiZfzvbMRTgxUVhWEdIzdP6XiHliCr6youbKda4itFcnnm1vCT7GcLoXI+HlsIfmL0ndCUA5Xpc9jPkJlTrN9k+gGn/zd/fQe+CtTrVc=
Message-ID: <a9e22dff0707160138v109e2080u96726906ccb8b716@mail.gmail.com>
Date: Mon, 16 Jul 2007 11:38:46 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: performance -cfs19 vs. -ck1 for 2.6.22
In-Reply-To: <20070716082917.GA1325@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707160112pc3b7bfcmc73adbd4edec670e@mail.gmail.com>
	 <20070716082917.GA1325@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo!

>>Could you run the
>>following script:
>>  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
I'll do that! But a little bit later - I have tested that on my home computer.

>>hm, is there no other workload on the system?
Workload: firefox, transmission(torrent client), gnome terminal, music player.

Now I think it could be not a scheduler issue but network subsystem
... but I've got such situation on previous kernels and w/o torrent
client running.
The problem is not in switching tabs in firefox but in _opening_new_url_.
I'm not good in Con's patches but are they touching network subsystem?
