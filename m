Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187Ab0AAXMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0AAXMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 18:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059Ab0AAXMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 18:12:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:33286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0AAXML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 18:12:11 -0500
Date: Fri, 1 Jan 2010 15:14:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Smith, GeoffX" <geoffx.smith@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] proc: Get/set timer slack through /proc
Message-ID: <20100101151437.17834b25@infradead.org>
In-Reply-To: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1D19@orsmsx510.amr.corp.intel.com>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1D19@orsmsx510.amr.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Dec 2009 13:01:49 -0800
"Smith, GeoffX" <geoffx.smith@intel.com> wrote:

> Subject: Get/set timer_slack_ns through /proc
> 
> This patch makes the timer_slack_ns parameter accessible through
> the /proc system.
> 
> On 9/1/2008, arjan@linux.intel.com submitted a patch to allow a
> process to set the timer slack value as part of the range timers
> feature.  Further, he noted that "Applications and admins can
> override this [the timer slack value] via the prctl()."
> 
> We have found this feature useful in attempting to reduce system
> wakeups caused by timer interrupts.  But we have also found that
> while applications can set their own timer slack value, there is no
> provision for setting the timer slack for another process -- prctl()
> only operates on the current process.  
> 

this statement is incorrect btw;
timerslack is explicitly inherited over exec, so you can have (and we
do have) a utility similar to the nice program, that launches an
application with a specific timer slack.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
