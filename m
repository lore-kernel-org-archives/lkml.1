Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbZGRGJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbZGRGJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 02:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZGRGJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 02:09:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZGRGJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 02:09:34 -0400
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
From: Andi Kleen <andi@firstfloor.org>
References: <19041.4714.686158.130252@notabene.brown>
Date: Sat, 18 Jul 2009 08:09:33 +0200
In-Reply-To: <19041.4714.686158.130252@notabene.brown> (Neil Brown's message of "Sat, 18 Jul 2009 10:08:10 +1000")
Message-ID: <8763dqwmhu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:
>
>  With 2TB drives easily available, more people will probably try
>  building arrays this big and we cannot just assume they will only do
>  it on 64bit hosts.

They should -- no 32bit fsck has any chance running on a 16TB volume.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
