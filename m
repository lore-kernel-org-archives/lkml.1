Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYFRPRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYFRPRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 11:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYFRPRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 11:17:03 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:27205 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYFRPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VuME9VT0KkzS/3Uk9EXohNYtALMwmqyTM3sKXDlMVhf7nit671VTvhtiWc0bLGD650
         +bccw7R8FxumNVUOCPUZqoifISKmik7Wyjdf78249LsB5N7BVosm0uFSdSIZDa8w3THA
         SIYh35blPyq0z5/LTrHPxylF4/w3y8AZuOIkc=
Message-ID: <ed038eb20806180816w5a4f9d6bt276dec1373758e08@mail.gmail.com>
Date: Wed, 18 Jun 2008 17:16:56 +0200
From: "Carl Henrik Lunde" <chlunde@ping.uio.no>
To: "Andrea Righi" <righi.andrea@gmail.com>
Subject: Re: [PATCH 1/3] i/o bandwidth controller documentation
Cc: balbir@linux.vnet.ibm.com, menage@google.com, matt@bluehost.com,
       roberto@unbit.it, randy.dunlap@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1212791250-32320-2-git-send-email-righi.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <> <1212791250-32320-2-git-send-email-righi.andrea@gmail.com>
X-Google-Sender-Auth: b068d246e5bd6ccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 00:27, Andrea Righi <righi.andrea@gmail.com> wrote:
[...]
> +3. Advantages of providing this feature
> +
> +* Allow QoS for block device I/O among different cgroups

I'm not sure if this can be called QoS, as it does not guarantee
anything but throttling?

> +* The bandwidth limitations are guaranteed both for synchronous and
> +  asynchronous operations, even the I/O passing through the page cache or
> +  buffers and not only direct I/O (see below for details)

The throttling does not seem to cover the I/O path for XFS?
I was unable to throttle processes reading from an XFS file system.

Also I think the name of the function cgroup_io_account is a bit too innocent?
It sounds like a inline function "{ io += bytes; }", not like
something which may sleep.

-- 
Carl Henrik
