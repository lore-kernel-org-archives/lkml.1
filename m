Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbXJNMEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbXJNMEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 08:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbXJNMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 08:03:59 -0400
Received: from main.gmane.org ([80.91.229.2]:50105 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbXJNMD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 08:03:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.23(.1) Regression? i915 oopses and panics
Date: Sun, 14 Oct 2007 14:03:39 +0200
Message-ID: <fet0ir$38b$1@ger.gmane.org>
References: <fesqkn$lml$1@ger.gmane.org>	 <21d7e9970710140341i25afc47cwdd9e441a0d2e2d0f@mail.gmail.com>	 <fesrv9$o97$1@ger.gmane.org> <21d7e9970710140438p3e1c176et6c33ed4d7738364e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-83-236-56-183.dynamic.qsc.de
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
In-Reply-To: <21d7e9970710140438p3e1c176et6c33ed4d7738364e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie schrieb:
>> I'm sorry, I forgot to mention that: As I _thought_ it had worked with
>> rc6, I already found that commit. I reverted it and got a panic again
>> (no trace, as I was in X), so this one doesn't seem to cause the problem.
>>
> 
> Okay I've spotted a potential bug that might lay hidden, try the
> attached patch to see if it helps..

I applied the patch, compiled i915.ko, rmmoded the old module, insmoded
the new one and started X. The issue seems to be gone, googleearth
starts again without any messages to syslog, so no oops and no panic.

Will you submit this patch to the stable team?

