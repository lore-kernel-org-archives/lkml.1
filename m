Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbYL1TTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbYL1TTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 14:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYL1TTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 14:19:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50816 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbYL1TTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 14:19:39 -0500
Message-ID: <4957D14B.60805@redhat.com>
Date: Sun, 28 Dec 2008 21:19:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
CC: x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] Remove interrupt stack table usage from x86_64 kernel
References: <1230238726-17506-1-git-send-email-avi@redhat.com> <87vdt5vfxc.fsf@basil.nowhere.org> <4956A0B1.1060908@redhat.com> <20081227224029.GB496@one.firstfloor.org> <49573FE7.9090802@redhat.com> <20081228131605.GC496@one.firstfloor.org> <49578896.8030703@redhat.com> <20081228190840.GD496@one.firstfloor.org> <4957CE78.6030706@redhat.com>
In-Reply-To: <4957CE78.6030706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> 1. Add per-cpu IDT

Or we could have just two IDTs - one with IST and one without.  I 
clocked LIDT at 58 cycles (and we need two per heavyweight switch), so 
it's not that wonderful.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

