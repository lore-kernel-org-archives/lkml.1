Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZFGHic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZFGHic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 03:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZFGHiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 03:38:25 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60894 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZFGHiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 03:38:24 -0400
To: avi@redhat.com
Cc: guillaume.thouvenin@ext.bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8 KVM] gcc 3.3 dies at emulate_2op_cl().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200906050539.n555dwAQ077095@www262.sakura.ne.jp>
	<4A2B5D0E.20002@redhat.com>
In-Reply-To: <4A2B5D0E.20002@redhat.com>
Message-Id: <200906071638.CIC52145.OFOQHLFSMOJVFt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 7 Jun 2009 16:38:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> > I think something is wrong with emulate_2op_cl() when compiled with gcc 3.3.5 .
> 
> This is on i386, not x86_64, yes?
> 
Yes. Building "make allmodconfig" using Debian Sarge on i686 machine.
