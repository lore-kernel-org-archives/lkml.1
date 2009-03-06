Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbZCFVG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbZCFVG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbZCFVGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:06:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35286 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbZCFVGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:06:10 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] cpufreq: Remove KERN_ERR output if nForce2 chipset not found
Date: Fri, 6 Mar 2009 16:06:04 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27.15-170.2.24.fc10.x86_64; KDE/4.2.0; x86_64; ; )
Cc: davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ada3adqid5v.fsf@cisco.com>
In-Reply-To: <ada3adqid5v.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061606.05975.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009 15:55:56 Roland Dreier wrote:
> Distribution kernels are building cpufreq drivers into the kernel to get
> faster boot; if the nForce2 driver is built in, then on systems that are
> not supported by the driver (ie nearly all current systems), the message
> 
>     cpufreq: No nForce2 chipset.
> 
> is printed at the KERN_ERR level, which means it goes to the console
> even if quiet boot is turned on.
> 
> The best way to handle this is just to delete the message, since the
> likelihood of it ever being of any use to anyone is very low, and other
> cpufreq drivers don't print anything if no matching hardware is found.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Nb: Matthew Garrett submitted a similar-but-different patch a week or
two ago on the cpufreq list that demoted the message to KERN_INFO.

-- 
Jarod Wilson
jarod@redhat.com
