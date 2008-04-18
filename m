Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYDRIIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYDRIIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYDRII2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:08:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52144 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbYDRII0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:08:26 -0400
Message-ID: <480856BD.3080903@firstfloor.org>
Date: Fri, 18 Apr 2008 10:07:25 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: mingo@elte.hu, akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <87od889m44.fsf@basil.nowhere.org> <20080418000634.GB5062@Krystal>
In-Reply-To: <20080418000634.GB5062@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
>> Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
>>> It allows placing immediate values (and therefore optimized trace_marks) in NMI
>>> code
>> Only if all your trace_mark infrastructure is lock less.
>>
>> -Andi
>>
> 
> It uses RCU-style updates and has been designed to be lockless from the
> ground up.

Wrong. If it causes vmalloc faults it is not lockless.

-Andi

