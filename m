Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbYFUODt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbYFUODt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYFUODl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:03:41 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35909 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYFUODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:03:41 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
From: Andi Kleen <andi@firstfloor.org>
References: <485C2875.2050204@goop.org> <485C4B0E.2090704@zytor.com>
Date: Sat, 21 Jun 2008 16:02:37 +0200
In-Reply-To: <485C4B0E.2090704@zytor.com> (H. Peter Anvin's message of "Fri, 20 Jun 2008 17:27:58 -0700")
Message-ID: <87bq1uyjgi.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jun 2008 13:55:21.0867 (UTC) FILETIME=[7279B5B0:01C8D3A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> There is no reason we couldn't do syscall for 32-bit native, but the
> only processor that would benefit would be K7, and that's far enough

K6 actually. K7 has sysenter AFAIK. The K6 syscall was also slightly different
and would need special case code.

-Andi
