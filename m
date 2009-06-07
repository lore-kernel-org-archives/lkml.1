Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZFGNVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZFGNVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZFGNVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:21:33 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:52943 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbZFGNVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=weRBk4SGcVdI45EgQs4SPyJls7kHtS0Uocle+tviGGQXSnYEXZGfjDutOY/OUdsVGS
         yo+4gvUZYYZeitCmGzohsO9084oa7TZ2YHoqu6iEMkjkWbG71A4yxMPntoWutmErLdpw
         d1DhIH40YCbfGh38rrZtHFyCUZYTb3SpqCDtY=
MIME-Version: 1.0
In-Reply-To: <D9VoutSOyXP.A.7vF.2Y7KKB@chimera>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.7vF.2Y7KKB@chimera>
Date: Sun, 7 Jun 2009 16:21:32 +0300
X-Google-Sender-Auth: 62a9a65e3fd30ab6
Message-ID: <84144f020906070621r1f480eaeief026d23662df380@mail.gmail.com>
Subject: Re: [Bug #13475] suspend/hibernate lockdep warning
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Young <hidave.darkstar@gmail.com>, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       trenn@suse.de, sven.wegener@stealer.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 12:52 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13475
> Subject         : suspend/hibernate lockdep warning
> Submitter       : Dave Young <hidave.darkstar@gmail.com>
> Date            : 2009-06-02 10:00 (6 days old)
> References      : http://marc.info/?l=linux-kernel&m=124393723321241&w=4

Looks like a cpufreq locking problem to me. Lets add some
get_maintainer.pl loving to the cc list. Can you post your .config
too, btw?

                                 Pekka
