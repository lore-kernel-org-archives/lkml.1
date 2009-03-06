Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZCFWBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZCFWBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbZCFWBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:01:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbZCFWBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:01:33 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] cpufreq: Remove KERN_ERR output if nForce2 chipset not found
Date: Fri, 6 Mar 2009 17:01:03 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27.15-170.2.24.fc10.x86_64; KDE/4.2.0; x86_64; ; )
Cc: davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ada3adqid5v.fsf@cisco.com> <200903061606.05975.jarod@redhat.com> <adaljrigw0a.fsf@cisco.com>
In-Reply-To: <adaljrigw0a.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061701.04348.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009 16:51:49 Roland Dreier wrote:
>  > Nb: Matthew Garrett submitted a similar-but-different patch a week or
>  > two ago on the cpufreq list that demoted the message to KERN_INFO.
> 
> Sorry, missed that.  I considered the demotion to KERN_INFO but a) no
> other cpufreq drivers seem to print anything if the device isn't found
> and b) I can't imagine a realistic case of when the message would *ever*
> be useful.

Good points. I wasn't favoring one or the other 'til now, but simply
returning -ENODEV does indeed seem to be more in line with what other
freq scaling drivers do.

-- 
Jarod Wilson
jarod@redhat.com
