Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbZHZA2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbZHZA2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZHZA2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:28:45 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:16170 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755542AbZHZA2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:28:44 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-cr-hashedpuzzle: ALHE Apkn Awsq DiXH D7y7 FGk6 G/2+ HI5K IHJ/ M4HE T6m6 VoKK WUZZ WrS0 W+uy XiKa;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAbwByAHYAYQBsAGQAcwBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA=;Sosha1_v1;7;{C3CCA6FB-EB20-4251-8280-7C771AF6EA88};YQBzAGkAbgBoAGEAQAB6AGUAdQBnAG0AYQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0A;Wed, 26 Aug 2009 00:28:31 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAYwBvAG4AcwBvAGwAZQBfAHAAcgBpAG4AdAA6ACAAYwBoAGEAbgBnAGUAIAB0AGgAZQAgAGYAdQBuAGMAdABpAG8AbgAgAGEAcABpACAAdABvACAAbQBhAGsAZQAgAGkAdAAgAGgAYQB2AGUAIABwAHIAaQBuAHQAawAgAHMAdAB5AGwAZQAgAGkAbgB0AGUAcgBmAGEAYwBlAA==
Content-class: urn:content-classes:message
Subject: RE: [PATCH] console_print: change the function api to make it have printk style interface
Date: Tue, 25 Aug 2009 17:28:31 -0700
x-cr-puzzleid: {C3CCA6FB-EB20-4251-8280-7C771AF6EA88}
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501EA926D@exchange.ZeugmaSystems.local>
In-Reply-To: <alpine.LFD.2.01.0908251717230.3218@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] console_print: change the function api to make it have printk style interface
Thread-Index: Acol4uveRpIIjaPcSbGbppIoASuVUgAAQu9Q
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local> <alpine.LFD.2.01.0908251717230.3218@localhost.localdomain>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>Don't do this. That's a 1kB stack frame right there. You'll overflow
the
>stack very quickly.

Ah! Of course you are correct! Can we simply have a macro instead of a
full blown function instead? If that is not acceptable, I will think of
something else to get around it.

Ani


