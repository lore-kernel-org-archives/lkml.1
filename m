Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZEUBYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZEUBYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 21:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZEUBYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 21:24:10 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:43944 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZEUBYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 21:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=IOwEAvNpQbSJ6a/ql8vZUuDpjqXHyFDPS1VbTb2zwo2uWhNXG6dTKISNvoKi0jcEgq
         P1mPfpZdoTCc/kFyjiumm7SJV9BU7UqPwx2+jN7E6adEvjNESY3UOG8TtQKcrlw+gQs7
         pvOmVxa+t43aTPZR/jsk+ciDqJcxSrpnF4IJA=
MIME-Version: 1.0
Date: Wed, 20 May 2009 18:16:56 -0700
Message-ID: <cf70f0210905201816g51d5d99ft35e8f33e2c470f5e@mail.gmail.com>
Subject: Confused with CONFIG_NO_HZ and CONFIG_HZ
From: Shivdas Gujare <shivdas.tech@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am confused with CONFIG_NO_HZ and CONFIG_HZ? What is the main
difference between it?
As per what I understood, CONFIG_NO_HZ is feature of tickless kernel,
where timer interrupts will be fired only if necessary,
and CONFIG_HZ decides the timeout of timer interrupts?

I came across description[1] from Ingo regarding CONFIG_NO_HZ as "if
there is no timer to be expired for say 1.5 seconds when
the system goes idle, then the system will stay totally idle for 1.5
seconds." then I don't understand how timer will remain unexpired
during idle if CONFIG_HZ=100,
i.e. 10ms timer timeout for timer interrupt and during such scenarios
who decides this 1.5 sec timeout.

It will be great help, if I get some more information regarding this.

Ref.
[1] http://kerneltrap.org/node/6750

Thanks and regards,
Shivdas Gujare
