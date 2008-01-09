Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYAITFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYAITFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYAITFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:05:10 -0500
Received: from gw.goop.org ([64.81.55.164]:59799 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbYAITFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:05:08 -0500
Message-ID: <47851AD1.2040604@goop.org>
Date: Wed, 09 Jan 2008 11:04:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10 of 10] xen: mask out PWT too
References: <patchbomb.1199829603@localhost> <ce684ed89b75370a4cfe.1199829613@localhost> <47849F29.76E4.0078.0@novell.com>
In-Reply-To: <47849F29.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> That's somewhat ugly, as it will need to be undone/modified for Dom0 and
> physical device access support. Jan
>   

Yes, I know, but its a quick workaround for a silent change in 
hypervisor behaviour.

The proper fix would probably mask them out of the supported_pte_flags, 
but that's a little more subtle to get right.

    J
