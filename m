Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZCFVwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZCFVwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZCFVvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:51:52 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:1199 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZCFVvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:51:51 -0500
X-IronPort-AV: E=Sophos;i="4.38,316,1233532800"; 
   d="scan'208";a="152117080"
From: Roland Dreier <rdreier@cisco.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Remove KERN_ERR output if nForce2 chipset not found
References: <ada3adqid5v.fsf@cisco.com> <200903061606.05975.jarod@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 06 Mar 2009 13:51:49 -0800
In-Reply-To: <200903061606.05975.jarod@redhat.com> (Jarod Wilson's message of
	"Fri, 6 Mar 2009 16:06:04 -0500")
Message-ID: <adaljrigw0a.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Mar 2009 21:51:49.0532 (UTC) FILETIME=[C0A0B5C0:01C99EA5]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Nb: Matthew Garrett submitted a similar-but-different patch a week or
 > two ago on the cpufreq list that demoted the message to KERN_INFO.

Sorry, missed that.  I considered the demotion to KERN_INFO but a) no
other cpufreq drivers seem to print anything if the device isn't found
and b) I can't imagine a realistic case of when the message would *ever*
be useful.

 - R.
