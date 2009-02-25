Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbZBYWUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbZBYWUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762579AbZBYWUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:20:18 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:57246 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762191AbZBYWUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:20:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hGdJTdBeRz1M8Qcedhy3yVI9dCjU9Xgs3TpZCxWWTma+iYK47IqcDu5scMo4uX7yKy
         fTqzED8G738XQ2hD3NJ625Q8iJVseSzquJRsLmPGR8Z7zGF1X03Ue95rLqLSh4bTorp8
         yfz1yLRD8YiYyiK1p4f2zyWB9o71Pb2SpQSk8=
MIME-Version: 1.0
In-Reply-To: <1235600169-26912-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1235600169-26912-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Wed, 25 Feb 2009 17:20:13 -0500
Message-ID: <8bd0f97a0902251420k7bd00c4fhda34004d1993975a@mail.gmail.com>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
From: Mike Frysinger <vapier.adi@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Bernd Schmidt <bernds_cb1@t-online.de>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 17:16, Uwe Kleine-König wrote:
> The current definition of CALLER_ADDRx isn't suitable for all platforms.
> E.g. for ARM __builtin_return_address(N) doesn't work for N > 0

afaik, the same applies to the Blackfin port.  we looked at
implementing __builtin_return_address(N) and decided it wasnt worth
the hassle.
-mike
