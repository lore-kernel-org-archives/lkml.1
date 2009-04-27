Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZD0Nfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZD0Nfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZD0Nfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:35:41 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:65088 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZD0Nfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:35:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NfJ0dsVh+leyzMEl6jFRU5/UKmNuTtqW61DL4yc9aU93AOC+EqMIoZEBHpBQZMzHNP
         HtKEB1bEz4ORnDbq9qRSrhUB+sToYkPM0cwxNs1h7mzLitpy79QQDqi1NPstoks/1JRR
         QOyQJQHbOi3dYMGliZxqaz6skSNry2SQaP0ws=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
	 <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
	 <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
	 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com>
	 <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com>
	 <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
Date: Mon, 27 Apr 2009 14:35:39 +0100
X-Google-Sender-Auth: e685f91475ddb627
Message-ID: <407d949e0904270635p7f87e3c3jcb1db0e61d4ed11e@mail.gmail.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
From: Greg Stark <gsstark@mit.edu>
To: David Rientjes <rientjes@google.com>
Cc: Zeno Davatz <zdavatz@gmail.com>, linux-kernel@vger.kernel.org,
       Hannes Wyss <hwyss@ywesee.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 8:55 PM, David Rientjes <rientjes@google.com> wrote:
> There is work being done on a per-cgroup lowmem notifier which would allow
> userspace to poll() on a device file and be notified of low memory
> situations so that it can react on its own (like killing a low priority
> task, expanding a cpuset, increasing a memcontroller limit, etc.)

Surely anything that important ought to be running with overcommit
disabled anyways.
