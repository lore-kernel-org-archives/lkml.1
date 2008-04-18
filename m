Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYDRLbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYDRLbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 07:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYDRLbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 07:31:14 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:34531 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYDRLbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 07:31:14 -0400
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: mingo@elte.hu, akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
From: Andi Kleen <andi@firstfloor.org>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal>
	<20080417201410.GB31616@Krystal> <87od889m44.fsf@basil.nowhere.org>
	<20080418000634.GB5062@Krystal>
Date: Fri, 18 Apr 2008 13:30:55 +0200
In-Reply-To: <20080418000634.GB5062@Krystal> (Mathieu Desnoyers's message of "Thu, 17 Apr 2008 20:06:34 -0400")
Message-ID: <87ej93bdsg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Apr 2008 11:24:09.0347 (UTC) FILETIME=[B8650530:01C8A146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
>
> It uses RCU-style updates and has been designed to be lockless from the
> ground up.

RCU is not necessarily NMI safe. In most cases RCU needs writer locks
which you cannot do with NMIs.

-Andi
