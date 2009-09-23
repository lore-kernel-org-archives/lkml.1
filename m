Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbZIWXDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbZIWXDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZIWXDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:03:32 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58797 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZIWXDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:03:31 -0400
To: andy753421@gmail.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Privilege dropping security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
	<4ABA892A.9090804@schaufler-ca.com>
	<20090923223110.GA1449@c.hsd1.tn.comcast.net>
In-Reply-To: <20090923223110.GA1449@c.hsd1.tn.comcast.net>
Message-Id: <200909240803.FHE43203.MFLOJFHFOOtVSQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 24 Sep 2009 08:03:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Spencer wrote:
> > And what do you propose as an interesting use case for dpriv?
> 
> I think the two most important things about dpriv is that it can be used
> by ordinary users and that is can create policies programmatically.
> 
> Being able to use dpriv as a non root user is pretty strait forward. For
> example, a user of a multi-user system may want to try some untrusted
> code without risking access to the rest of the system:
You need to add some quota, or malicious/careless users can consume
all kernel memory and crash the system...
