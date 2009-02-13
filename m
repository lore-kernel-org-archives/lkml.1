Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZBMPsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZBMPsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZBMPsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:48:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:8240 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZBMPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:48:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B7M2E1JwlbExQR+dgFpnVQg5OLD0HRGV4Np2RqPuvdc1s+87u550+z7aI48uU7cceV
         usl7UjtxcEOtL/lhazgBaJ8+kcV/vciz0Z7vAf0Hj/XJRQp5yTNJBl72yVmoYNl+VJ74
         lNGHftfpYiSS2UncRqXgVsKaUXXkiux0f83Z4=
MIME-Version: 1.0
In-Reply-To: <20090213140421.5698.86876.stgit@warthog.procyon.org.uk>
References: <20090213140421.5698.86876.stgit@warthog.procyon.org.uk>
Date: Sat, 14 Feb 2009 00:48:42 +0900
X-Google-Sender-Auth: e902def501f813fc
Message-ID: <2f11576a0902130748h313864b6sa50ad038ab011fc0@mail.gmail.com>
Subject: Re: [PATCH] User namespaces: Only put the userns when we unhash the 
	uid
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, jmorris@namei.sys, akpm@linux-foundation.org,
       serue@us.ibm.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, containers@lists.osdl.org, snakebyte@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Serge E. Hallyn <serue@us.ibm.com>
>
> uids in namespaces other than init don't get a sysfs entry.
>
> For those in the init namespace, while we're waiting to remove
> the sysfs entry for the uid the uid is still hashed, and
> alloc_uid() may re-grab that uid without getting a new
> reference to the user_ns, which we've already put in free_user
> before scheduling remove_user_sysfs_dir().
>
> Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Acked-by: David Howells <dhowells@redhat.com>
> Tested-by: Ingo Molnar <mingo@elte.hu>

ok, thanks good patch.
  Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
