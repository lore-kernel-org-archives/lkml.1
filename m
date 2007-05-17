Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbXEQRPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbXEQRPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXEQRPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:15:36 -0400
Received: from gw.goop.org ([64.81.55.164]:51140 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbXEQRPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:15:35 -0400
Message-ID: <464C8DBA.80506@goop.org>
Date: Thu, 17 May 2007 10:15:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: strange GPF when panicing under kvm
References: <464B9E19.6050902@goop.org> <464C574C.5020201@qumranet.com>
In-Reply-To: <464C574C.5020201@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> (that msr can force trapping of the pause instruction, even though
> there's no good reason to do it, and kvm wouldn't inject a gp if it
> did anyway).

Hm, yeah, its strange; clearly its running "pause" in normal use, so it
can't be the instuction itself which is causing the problem.  The MSR is
7781fffe0401e172 btw.

    J

