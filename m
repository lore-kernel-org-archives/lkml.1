Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbYFES3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbYFES3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYFES3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:29:22 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:49311 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYFES3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:29:21 -0400
Date: Thu, 5 Jun 2008 20:28:49 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: kvm: unable to handle kernel NULL pointer dereference
Message-ID: <20080605182847.GA12176@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080601084802.GA3146@yamamaya.is-a-geek.org> <4846716E.5000506@qumranet.com> <20080604181019.GB10897@yamamaya.is-a-geek.org> <20080605042535.GC30402@sequoia.sous-sol.org> <20080605060931.GA11704@yamamaya.is-a-geek.org> <20080605072728.GF30402@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080605072728.GF30402@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> Sorry, my math was bad.  I gave you 0xffffffff8021d44f + 7 + 0x6f9cba,
> but it should have been 0xffffffff8021d44f - 17 + 0x6f9cba.  Which is
> correct (as one would hope, it was a grasp at straws).
> 
> Oh, wait.  Is this a laptop?  Do you suspend/resume?  Suspend will free
> svm_data, and on resume, any launching a guest will definitely hit the
> oops you are seeing.

No, this is my desktop, but I hibernate daily and always see below
message.

> Do you ever see this in dmesg?
> 
>   svm_cpu_init: svm_data is NULL on 0

Yes:
[...]
PM: Creating hibernation image: 
PM: Need to copy 126181 pages
PM: Normal pages needed: 126181 + 1024 + 38, available pages: 397721
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
svm_cpu_init: svm_data is NULL on 0
[...]

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
