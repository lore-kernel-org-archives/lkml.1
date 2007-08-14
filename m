Return-Path: <linux-kernel-owner+w=401wt.eu-S933749AbXHNSag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbXHNSag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933608AbXHNSaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:30:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:22913 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563AbXHNSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mN5LOcj7+kTAh3yzlp3SiZUNNC6jkp6nh5sTGNhpPcM2IJyCflZ38ilG4FtW3j20/ibzxTV8mC65pVxkBCGG6ne7wtoyF5aGVvfkWKr55A+3DzqW9tyc8PP7h81ioFPrZWnpvmOAoXyrdAjacVWuCHsfzAfiPr9rhe5+fHi6JvI=
Message-ID: <af57f1ac0708141130v729fa636k3150673809ec20a8@mail.gmail.com>
Date: Tue, 14 Aug 2007 22:30:01 +0400
From: "oleg 123" <123.oleg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: linux kernel 2.6.18-20 bug: rcu_read_unlock in __sock_create
In-Reply-To: <af57f1ac0708141125w190a6505r1159c29a689eec01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <af57f1ac0708141125w190a6505r1159c29a689eec01@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
There is a bug in __sock_create() function (net/socket.c).
If an error occur in LSM hook security_socket_post_create, then unneeded
rcu_read_unlock() is made in __sock_create.

I wish to be personally CC'ed the answers/comments posted
