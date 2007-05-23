Return-Path: <linux-kernel-owner+w=401wt.eu-S1763549AbXEWSDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763549AbXEWSDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbXEWSC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:02:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:43835 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698AbXEWSC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bEbRhne5YkMy+zG9VYTLWx85Gofxf3mArZjzlSS+Xbnk1FMFwdD3PciT9Q9nPtoCSkPxD6+yJa20L22tS59BGI5zZdRafK9N5ZKGsIkFuK6734v5RfDKwS1G9k6f9egZuN6jcgunJEoutR7wH+C746aQ5gEz+lcifG0RrRQ24ic=
Subject: [RFC 1/5] inode reservation v0.1
From: coly <colyli@gmail.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 24 May 2007 02:03:24 +0800
Message-Id: <1179943404.4179.52.camel@coly-t43.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is only experimental, just have a try whether the
subdirectory inode reservation idea works. Now the answer is it works,
and I am working on an improved version for this patch.

The basic idea of subdirecctory inode reservation is to avoid
unnecessary redundant meta data writing and hard disk seeking. Detailed
idea can be found here:http://lkml.org/lkml/2007/3/26/180

This email has another 4 extra parts:
1) ext4 kernel patch
2) e2fsprogs patch
3) current benchmark
4) next step working

The reason to release this unstable patch is:
* I want others to know I am working on it.
* The result of benchmark indecates that this work maybe is valuable.
* Hope others can give me feedback at very basic phase of this patch.

I should thank Adreas Dilger, who firstly introduces this idea to me.
Also I should thank other friends in #linuxfs at irc.oftc.org, great
helps to me.

In the next several months, I will try best to write a usable patch :-)


Coly

