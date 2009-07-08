Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZGHBTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZGHBTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 21:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZGHBSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 21:18:53 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:62779 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZGHBSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 21:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YKhwvvv7u0NCnEYntxjgOyrMNUspNd0E5xvuWeVERVtLYgEP35vgS8pjzq3L5imL/R
         UJIv5aD+bdlDALvbGlLpDgs+NDtKhr4Z2A461dsYNfBm6doZjPO90aPH96oNWUfzxJGm
         xFlPsW4hmvTzMBFXWKkrWaL9J8iF2L2v2BUXc=
MIME-Version: 1.0
In-Reply-To: <200907050823.43743.gene.heskett@verizon.net>
References: <200907050823.43743.gene.heskett@verizon.net>
Date: Tue, 7 Jul 2009 18:18:47 -0700
X-Google-Sender-Auth: 991ae34d1475fc35
Message-ID: <1f1b08da0907071818l1bae3256s30de304ed5ba3fa9@mail.gmail.com>
Subject: Re: 2.6.30.1
From: john stultz <johnstul@us.ibm.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 5, 2009 at 5:23 AM, Gene Heskett<gene.heskett@verizon.net> wrote:
> Just a heads up on 2.6.30.1, from logwatch's email:
>
>  --------------------- XNTPD Begin ------------------------
>
>
>  Time Reset 47 times (total: 11.411157 s  average: 0.242791 s)
>
>  Total synchronizations 74 (hosts: 4)
>
>  ---------------------- XNTPD End -------------------------
> 2.6.30 didn't, with a lot more uptime, appear to need near as much support
> from the pool.ntp.org folks.

I don't see anything in the 2.6.30.1 patch that would effect NTP.  Do
you have any peerstats/clockstats data? What does ntpdc -c peers and
ntpdc -c kerninfo show?

thanks
-john
