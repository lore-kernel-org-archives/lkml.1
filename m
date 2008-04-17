Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYDQWCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYDQWCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 18:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYDQWCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 18:02:36 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:43749 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYDQWCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 18:02:36 -0400
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: mingo@elte.hu, akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
From: Andi Kleen <andi@firstfloor.org>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal>
	<20080417201410.GB31616@Krystal>
Date: Fri, 18 Apr 2008 00:01:47 +0200
In-Reply-To: <20080417201410.GB31616@Krystal> (Mathieu Desnoyers's message of "Thu, 17 Apr 2008 16:14:10 -0400")
Message-ID: <87od889m44.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Apr 2008 21:55:00.0900 (UTC) FILETIME=[AF43E640:01C8A0D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
>
> It allows placing immediate values (and therefore optimized trace_marks) in NMI
> code

Only if all your trace_mark infrastructure is lock less.

-Andi

