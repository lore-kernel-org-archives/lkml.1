Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZEGSeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZEGSeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZEGSdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:33:53 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35720 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751251AbZEGSdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:33:52 -0400
Date: Thu, 7 May 2009 13:34:15 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <1241717849.6311.1554.camel@laptop>
Message-ID: <alpine.DEB.1.10.0905071332280.22107@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>  <1241560625.8665.17.camel@alok-dev1>  <alpine.DEB.1.10.0905071010170.24528@qirst.com>  <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop> 
 <alpine.DEB.1.10.0905071317270.22107@qirst.com> <1241717849.6311.1554.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Peter Zijlstra wrote:

> Somehow people like involuntary preemption to happen at slightly more
> than glacial pace as well.

These intervals could be dynamically established by the scheduler.

If there is a single process running on a processor and no other process
is contending then there is no need to do involuntary preemption.
