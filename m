Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbYKYOlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYKYOlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYKYOlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:41:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50676 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYKYOlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:41:44 -0500
To: =?us-ascii?Q?=3D=3Futf-8=3Fq=3FT=3DC3=3DB6r=3DC3=3DB6k=3D20Edwin=3F=3D?= 
	<edwintorok@gmail.com>
Cc: mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/2] tracing: identify which executable object the userspace address belongs to
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com>
	<1227353328-16104-3-git-send-email-edwintorok@gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 25 Nov 2008 09:40:29 -0500
In-Reply-To: <1227353328-16104-3-git-send-email-edwintorok@gmail.com> (edwintorok@gmail.com's message of "Sat, 22 Nov 2008 13:28:48 +0200")
Message-ID: <y0my6z798de.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com> writes:

> Impact: modify+improve the userstacktrace tracing visualization feature
> [...]
> You'll see stack entries like:
>    /lib/libpthread-2.7.so[+0xd370]
> [...]

Can you suggest an actual distribution & architecture where this
facility may be tested/used?  It appears to require frame-pointer
stuff that AFAIK is not generally turned on for user-space.

- FChE
