Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYGAVLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYGAVLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYGAVLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:11:46 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:5706 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYGAVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:11:45 -0400
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
From: Andi Kleen <andi@firstfloor.org>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>
	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>
	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>
	<485BE80E.10209@goop.org>
	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
Date: Tue, 01 Jul 2008 23:11:43 +0200
In-Reply-To: <m1d4lxgwxj.fsf@frodo.ebiederm.org> (Eric W. Biederman's message of "Tue, 01 Jul 2008 13:40:40 -0700")
Message-ID: <874p79tils.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2008 21:04:22.0210 (UTC) FILETIME=[090BDA20:01C8DBBE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:
>
> Has anyone investigated using the technique gcc uses for thread local storage?

I investigated a long time ago (given when the binutils/gcc support
was much more primitive) and my conclusion back then was that doing 
the same for kernel module (negative addresses) would need 
new relocation types.  And the pain of a binutils change didn't
seem worth it.

-Andi
