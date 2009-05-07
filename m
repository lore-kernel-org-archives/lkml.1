Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbZEGTtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbZEGTtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZEGTtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:49:15 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:41123 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751668AbZEGTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:49:15 -0400
Date: Thu, 7 May 2009 15:38:18 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <1241723854.11251.166.camel@twins>
Message-ID: <alpine.DEB.1.10.0905071537390.14051@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>  <1241560625.8665.17.camel@alok-dev1>  <alpine.DEB.1.10.0905071010170.24528@qirst.com>  <1241716053.6311.1514.camel@laptop>  <alpine.DEB.1.10.0905071318570.22107@qirst.com> 
 <1241718302.6311.1573.camel@laptop>  <alpine.DEB.1.10.0905071342250.22107@qirst.com> <1241723854.11251.166.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Peter Zijlstra wrote:

> > What are high context switch rates? 1000 HZ? Generally it seems that
> > context switches are bad for cpu caches and thus to be avoided.
>
>
> We're talking about in excess of 250k switches a second.

Timer resources are not processor specific? Why such a high rate?

