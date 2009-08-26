Return-Path: <linux-kernel-owner+w=401wt.eu-S932755AbZHZA6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbZHZA6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254AbZHZA6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:58:06 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:21838 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821AbZHZA6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:58:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-cr-hashedpuzzle: Bv6w CHkh FKjC FL4w FM5M KMJh KQXM K+bE LR9m McJz OOwY O3/R PDcG QDBg QlcY S3ED;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAbwByAHYAYQBsAGQAcwBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA=;Sosha1_v1;7;{17FE0742-FE46-4843-B289-0F6D8A2E3881};YQBzAGkAbgBoAGEAQAB6AGUAdQBnAG0AYQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0A;Wed, 26 Aug 2009 00:57:52 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAYwBvAG4AcwBvAGwAZQBfAHAAcgBpAG4AdAA6ACAAYwBoAGEAbgBnAGUAIAB0AGgAZQAgAGYAdQBuAGMAdABpAG8AbgAgAGEAcABpACAAdABvACAAbQBhAGsAZQAgAGkAdAAgAGgAYQB2AGUAIABwAHIAaQBuAHQAawAgAHMAdAB5AGwAZQAgAGkAbgB0AGUAcgBmAGEAYwBlAA==
Content-class: urn:content-classes:message
Subject: RE: [PATCH] console_print: change the function api to make it have printk style interface
Date: Tue, 25 Aug 2009 17:57:52 -0700
x-cr-puzzleid: {17FE0742-FE46-4843-B289-0F6D8A2E3881}
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501EA9272@exchange.ZeugmaSystems.local>
In-Reply-To: <alpine.LFD.2.01.0908251730530.3218@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] console_print: change the function api to make it have printk style interface
Thread-Index: Acol5cPwVWFb8VEpTba83nHRQ5wZyQAAbZFw
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local> <alpine.LFD.2.01.0908251717230.3218@localhost.localdomain> <DDFD17CC94A9BD49A82147DDF7D545C501EA926D@exchange.ZeugmaSystems.local> <alpine.LFD.2.01.0908251730530.3218@localhost.localdomain>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>A macro is what others are generally doing.


Linus, 

I completely agree with you on both points. When I first saw this
interface, the first question that popped in my mind was "why is it even
here?" And the very next question I asked myself was "why is this isn't
a macro?" 

As far as I can see, except for arch/ia64/kernel/head.S, among the codes
that actually uses this interface, others are wrapped within #if 0 ...
#endif blocks. So effectively, this is not being used at all :)


Cheers,

Ani

