Return-Path: <linux-kernel-owner+w=401wt.eu-S934786AbZJNPzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786AbZJNPzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934739AbZJNPzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:55:43 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:37669 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934737AbZJNPzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:55:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=P2hc61JZuOJObe933kqDmKwuu/Zcp1jDmWRxYA8F68GPJv0U6eiVDzqh/ktpM4XZSa
         37M6c9v8kIMvNDJekwjaEs76nkDDsMONxj59GDDCZHijFo3R/j17DKYNAx2xUG+orl/z
         JAHF/H6ZmTYTFlDVNiEORXd6D5HqgnIRvuCbU=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gregkh@suse.de, tglx@linutronix.de
Subject: Re: [tip:bkl/drivers] drivers: Remove BKL from misc_open
Date: Wed, 14 Oct 2009 17:55:00 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-tip-commits@vger.kernel.org
References: <20091010153349.237173041@linutronix.de> <tip-40b798efe3460797a4ac928ee2e038774e2758eb@git.kernel.org>
In-Reply-To: <tip-40b798efe3460797a4ac928ee2e038774e2758eb@git.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910141755.00774.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  40b798efe3460797a4ac928ee2e038774e2758eb
> Gitweb:     http://git.kernel.org/tip/40b798efe3460797a4ac928ee2e038774e2758eb
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Sat, 10 Oct 2009 15:35:43 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 14 Oct 2009 17:33:32 +0200
> 
> drivers: Remove BKL from misc_open
> 
> misc_open() is already serialized with misc_mtx. Remove the BKL
> locking which got there via the BKL pushdown.

Did you check the misc drivers to make sure this is not silently
removing the BKL from drivers that need it?

	Arnd <><
