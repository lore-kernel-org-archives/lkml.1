Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbXBSNdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbXBSNdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbXBSNdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:33:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59577 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbXBSNdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:33:08 -0500
Subject: Re: Question about setting affinity in 2.4
From: Arjan van de Ven <arjan@infradead.org>
To: Phy Prabab <phyprabab@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2fe399760702181802q39e75b42iea7f80124506f169@mail.gmail.com>
References: <2fe399760702181802q39e75b42iea7f80124506f169@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 19 Feb 2007 14:33:06 +0100
Message-Id: <1171891986.3531.34.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 18:02 -0800, Phy Prabab wrote:
> Hello everyone,
> 
> I am trying to set affinity on a program to make sure I can get the
> best use of the cache as possible and to eliminate as much noise as
> possible with running my program.  I have tried unsuccessfully to set
> affinity using sched_set/getaffinity and the CPU_SET macros.  In
> particular, I can not seem to get the process to use affinity I
> specify as in:
> 
> int main () {
>   cpu_set_t mask;
>   cpu_set_t setmask;
>   long long x;
>   double foo;
>   printf("Mask set to %08lx\n", sched_getaffinity(0, &mask));

       int sched_setaffinity(pid_t pid, unsigned int cpusetsize,
                             cpu_set_t *mask);


sched_setaffinity takes 3 not 2 parameters.



