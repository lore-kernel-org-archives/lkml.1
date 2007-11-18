Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbXKRT55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbXKRT55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 14:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXKRT5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 14:57:49 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:49258 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbXKRT5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 14:57:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=X1LujqERitjZgSz6e2B89c5VoR186+pvBqZrgeR2h7nj/eM/4YrmRJK8hIqfhPxttFYDFrgx2OvX95NOsUx3HmQgtxg8DOPr+DD4ltNNKFApxzLwBx2zJEzGCC/J9XV8G+St7iHg4IpI6yjWcWbI/qXW9Q1Q/aN1RHeoc8X2W5I=
Message-ID: <4740992D.9030906@gmail.com>
Date: Sun, 18 Nov 2007 20:57:33 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: apm emulation driver broken ?
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com> <200711171059.57462.rjw@sisk.pl> <473ED715.9000004@gmail.com> <200711171346.51363.rjw@sisk.pl>
In-Reply-To: <200711171346.51363.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 17 of November 2007, Franck Bui-Huu wrote:
>> ok so now we agreed on this point, can we assert that a user
>> land thread waiting for an event in an UNINTERRUPTIBLE state
>> will prevent a suspend to happen ?
> 
> Yes.
> 

So this driver seems really broken and actually I'm wondering if
it's used by anyone...

See the call to wait_even() made by apm_ioctl(). If any processes
run this, it will prevent the system to suspend...

And no, I don't know why call wait_event() is called.

		Franck
