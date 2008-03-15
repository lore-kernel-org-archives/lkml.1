Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYCOQca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYCOQca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 12:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYCOQcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 12:32:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:32107 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYCOQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 12:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rBSyoJDh614gBsrwRMAqRErlSXgxKvmeBLw3g08ug9B4L0M0BGVpVZgMGAWg1JnYYhWE+2zbdL5zqZ3k3H5X0TB3zMY9RQO88u4LcuL2In8n5y6NmWELsLLTw4aIb1SPaY9rkkmqQGMptq4cn8ZcHdhskZt333YBvcdjsUxVw+w=
Message-ID: <2c0942db0803150932s6e654e28g5255ac7af451741b@mail.gmail.com>
Date: Sat, 15 Mar 2008 09:32:16 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Marc Perkel" <mperkel@yahoo.com>, Netdev <netdev@vger.kernel.org>
Subject: Re: TCP stack optimization for high number of connections [OT]
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <873209.1586.qm@web52510.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <873209.1586.qm@web52510.mail.re2.yahoo.com>
X-Google-Sender-Auth: 6ad8d0c9215c41cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC:netdev added.)

On Sat, Mar 15, 2008 at 8:47 AM, Marc Perkel <mperkel@yahoo.com> wrote:
> I'm running a front end spam filtering service and I
>  get a lot of incoming connections but not a lot of
>  volume of traffic. I'm experiencing some high loads
>  and I think it might be related to the volume of
>  connections it's processing. I often will be connected
>  to 2500 email servers at once and a lot more that are
>  trying to connect and being denied.
>
>  My question - are there any optimizations I can do to
>  make the TCP faster for high number of short lived
>  connections?
>
>  Also - how much do iptable entries slow things down
>  and is there any optimizations for that?
>
>
>  Marc Perkel
>  Junk Email Filter dot com
>  http://www.junkemailfilter.com
