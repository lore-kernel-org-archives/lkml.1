Return-Path: <linux-kernel-owner+w=401wt.eu-S936520AbXJSWSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936520AbXJSWSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765293AbXJSWSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:18:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbXJSWSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:18:11 -0400
Message-ID: <47192D20.8090608@redhat.com>
Date: Fri, 19 Oct 2007 18:18:08 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.23] tasks stuck in running state?
References: <47192425.6020507@garzik.org> <47192763.9050004@redhat.com> <47192999.6010607@garzik.org>
In-Reply-To: <47192999.6010607@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2007 06:03 PM, Jeff Garzik wrote:
>> [jgarzik@pretzel misc-2.6]$ strace -p8484
>> Process 8484 attached - interrupt to quit
> [sits there, chewing up CPU grepping a 47-line header file]
> 

And sysrq-p is pretty useless unless you can force the keyboard
interrupt and the spinning process onto the same CPU.

