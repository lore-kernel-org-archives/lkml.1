Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYIYOo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYIYOo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYIYOoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:44:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:39305 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYIYOoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hsuM3CEZG7oL684AFFSMZoAT8iyjEnvk27R9dxeLFW++trgitEi1sVyP+08ev3a6Vv
         jA0WeKZSsgAhPVEl2MAN+RByQSnM2bgjaJaBpDPAvjkhy8lppeQxrBbFaYN31fj2xxXa
         xe2kvdvfCmnW+xUhLCoy+iuzeMNY2EyrOXtgw=
Message-ID: <c62985530809250744t3ce0011ajebd8343eb748cf24@mail.gmail.com>
Date: Thu, 25 Sep 2008 16:44:08 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [Patch -tip 3/3] Tracing/ftrace: Don't consume entries unhandled by mmiotrace
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080925173435.5f525557@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DB8408.7080408@gmail.com>
	 <20080925173435.5f525557@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/25 Pekka Paalanen <pq@iki.fi>:
> NACK.
>
> mmiotrace's log output is stricly specified, the standard/default
> printing functions may NOT be used. The output is supposed to be
> machine readable in addition to human readable.
>
> The ftrace infrastructure assumes there is only one active tracer
> at a time, therefore destroying unhandled entries is not a problem.
>
> --
> Pekka Paalanen
> http://www.iki.fi/pq/
>

Hi Pekka.

It's up to you.
I just guessed that one would trace IO and stack for example.
Or why not IO and functions: This sounds to me very useful (who
performed this io..?)

As you want....

Regards...
