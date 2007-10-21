Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXJUP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXJUP7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 11:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXJUP7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 11:59:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbXJUP7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 11:59:32 -0400
Message-ID: <471B7752.7050306@redhat.com>
Date: Sun, 21 Oct 2007 11:59:14 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.23] tasks stuck in running state?
References: <47192763.9050004@redhat.com>	<47192999.6010607@garzik.org>	<47192D20.8090608@redhat.com> <20071019.170140.45897518.davem@davemloft.net>
In-Reply-To: <20071019.170140.45897518.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2007 08:01 PM, David Miller wrote:
> 
> What might be appropriate is just to get a one-line program counter
> dump on every cpu via some new sysrq keystroke.
> 

IIRC -mm had something like this but it was buggy because we were
sending IPIs to each processor asking them to print their state.
Maybe it would work if we had a way of making them dump their
state to a memory location and then collected and printed it from
the CPU that's handling the sysrq.
