Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbXJJCZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbXJJCZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 22:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXJJCZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 22:25:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:49361 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXJJCZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 22:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AEFq13volWp6g7+8q7+jpsxP98a3RfE9ojSuKGzlJCSBGz0q6H7MjtL8hXsTCHigQ2hX5KhwoANUAkEsvxzykUiDyjS7YdyUb99nAc348eq+JctdPlL3sQitHEb+iDlSypZtSJo28nDuUx9RCYaPoM5JPw0fxCE6UzhyH7FNFHc=
Message-ID: <470C37FA.8060706@gmail.com>
Date: Wed, 10 Oct 2007 11:24:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] The return of the sysfs oops
References: <730342.60752.qm@web52909.mail.re2.yahoo.com>
In-Reply-To: <730342.60752.qm@web52909.mail.re2.yahoo.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Rankin wrote:
> Hi,
> 
> Do you remember that oops in sysfs a few versions ago? (Kernel bug 8198) Well, it's baaaack in
> 2.6.22.9...

This isn't really related to sysfs.  It seems module count was too low
and went away while there still were holders.  What were you doing when
it happened?  Can you reproduce it?

-- 
tejun
