Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbXELT5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbXELT5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXELT5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:57:37 -0400
Received: from gw.goop.org ([64.81.55.164]:53597 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759918AbXELT5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:57:36 -0400
Message-ID: <46461C30.8050108@goop.org>
Date: Sat, 12 May 2007 12:57:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bastian Blank <bastian@waldi.eu.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Xen-devel <xen-devel@lists.xensource.com>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [patch 19/28]xen: Add early printk support via hvc
 console
References: <20070511000643.025196000@goop.org>	<20070511001204.948444000@goop.org> <20070512190813.GA17757@wavehammer.waldi.eu.org>
In-Reply-To: <20070512190813.GA17757@wavehammer.waldi.eu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bastian Blank wrote:
> On Thu, May 10, 2007 at 05:07:02PM -0700, Jeremy Fitzhardinge wrote:
>   
>> +#ifdef CONFIG_XEN
>>     
>
> xenboot_console is only available with CONFIG_HVC_XEN.
>   

Good point.  I added CONFIG_HVC_XEN, but forgot to update this.

    J
