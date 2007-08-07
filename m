Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbXHGJSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbXHGJSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbXHGJSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:18:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:11645 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbXHGJSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cbYaRKwHm+w+OdkMB7yz2OwVuwh2EpVkIyOYemlWZsKkDybwSyl3FEnQV8mYt+XUqe5zLghx4vNF9tA3/9W89ltDExMEy3DS1qbueFVNiv9pDowsfPHCN1zjEZcl/exs/fcmLq78ouM3fBDwKOjkyxG7/Qt7wpU5iGs6kcHU9N8=
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Michael Sedkowski <sedmich@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <46B817AB.30105@gmail.com>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>
	 <1186411815.4355.7.camel@nx6310>
	 <20070806150159.GC31615@khazad-dum.debian.net>
	 <200708061732.03425.rjw@sisk.pl>  <46B75459.9020204@gmail.com>
	 <1186424492.4355.1.camel@nx6310>  <46B76BBC.9010107@gmail.com>
	 <1186438698.4402.6.camel@nx6310>  <46B817AB.30105@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 07 Aug 2007 11:18:39 +0200
Message-Id: <1186478319.3705.3.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 07-08-2007, Wt o godzinie 15:56 +0900, Tejun Heo napisał(a):
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
> Always       -       388
> 
> I think this is the one.  You can test it by forcefully powering off
> the
> machine (press power button for several secs or disconnect AC and
> battery) and see whether the count increases.
> 
When I forcefully power off using the power button the raw value [last
one] rise by 1 point from 389 to 390. When I power off normally with
linux it remains constant.
Now could some one please explain to me what does that mean and am I in
danger of data loss?

