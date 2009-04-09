Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbZDIMFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbZDIMFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932548AbZDIMFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:05:37 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55471 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbZDIMFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:05:36 -0400
To: jmorris@namei.org
Cc: alan@redhat.com, hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: current->mm == NULL in security_vm_enough_memory().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp>
	<alpine.LRH.2.00.0903261236580.30336@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0903261236580.30336@tundra.namei.org>
Message-Id: <200904092105.HBG52601.MHFOtQOLSVFOFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 9 Apr 2009 21:05:33 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> khelper is a kernel thread, so it should not have an ->mm, but I wonder
> why this hasn't shown up before.  Odd...

I don't see this message for 2.6.29 and earlier.
As of 2.6.30-rc1, this problem is not solved yet.
I think something happened between 2.6.29 and 2.6.30-rc1.

http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc1.txt
http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc1
