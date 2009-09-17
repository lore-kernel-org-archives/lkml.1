Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZIQOJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZIQOJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZIQOJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:09:09 -0400
Received: from mail-pz0-f195.google.com ([209.85.222.195]:48413 "EHLO
	mail-pz0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131AbZIQOJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:09:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RRf/ix6cRDtvmhrzXX5jBQVSmEGjDLioD6M7QoxItlXW8SKh5VYBNnO41MU6Lq6ziM
         KV5CVwWeOxZ5dYjP+svt5/JTmNqna1Q9Jej+SRzHyF9fUFBdcll2DSi0NqVVzcW83Mc9
         l57GH7mlDX0VZ9iuDcT7YzfkUbY3pse4JnmtA=
MIME-Version: 1.0
In-Reply-To: <1249551602-13147-1-git-send-email-tom.leiming@gmail.com>
References: <1249551602-13147-1-git-send-email-tom.leiming@gmail.com>
Date: Thu, 17 Sep 2009 22:01:13 +0800
Message-ID: <d82e647a0909170701o6398fcb9wcaa6e9f2e7a08743@mail.gmail.com>
Subject: Re: [PATCH 1/2] driver core: introduce devtmpfs_wait_for_dev() v1
From: Ming Lei <tom.leiming@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/6  <tom.leiming@gmail.com>:
> From: Ming Lei <tom.leiming@gmail.com>
>
> This patch introduces devtmpfs_wait_for_dev(), which is based on devtmpfs
> and can be used to remove polling for root device before mounting rootfs.
>
> This patch also gives a generic and simple way to wait for a device in
> kernel mode based on devtmpfs.
>
> This version takes Kay Sievers's suggestion: pass relative path to
> devtmpfs_wait_for_dev(), for devtmpfs has no clue where it is
> mounted.
>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Hi, Greg

Since devtmpfs has been merged into mainline, would you mind
queuing  the 2 patches into your tree now?

Thanks.

-- 
Lei Ming
