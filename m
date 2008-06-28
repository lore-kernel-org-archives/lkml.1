Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYF1MXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYF1MXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYF1MX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:23:27 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:44196 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYF1MX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:23:27 -0400
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 15/39] don't save ebx in putuser_32.S
From: Andi Kleen <andi@firstfloor.org>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
	<1214602486-17080-2-git-send-email-gcosta@redhat.com>
	<1214602486-17080-3-git-send-email-gcosta@redhat.com>
	<1214602486-17080-4-git-send-email-gcosta@redhat.com>
	<1214602486-17080-5-git-send-email-gcosta@redhat.com>
	<1214602486-17080-6-git-send-email-gcosta@redhat.com>
	<1214602486-17080-7-git-send-email-gcosta@redhat.com>
	<1214602486-17080-8-git-send-email-gcosta@redhat.com>
	<1214602486-17080-9-git-send-email-gcosta@redhat.com>
	<1214602486-17080-10-git-send-email-gcosta@redhat.com>
	<1214602486-17080-11-git-send-email-gcosta@redhat.com>
	<1214602486-17080-12-git-send-email-gcosta@redhat.com>
	<1214602486-17080-13-git-send-email-gcosta@redhat.com>
	<1214602486-17080-14-git-send-email-gcosta@redhat.com>
	<1214602486-17080-15-git-send-email-gcosta@redhat.com>
	<1214602486-17080-16-git-send-email-gcosta@redhat.com>
Date: Sat, 28 Jun 2008 14:10:41 +0200
In-Reply-To: <1214602486-17080-16-git-send-email-gcosta@redhat.com> (Glauber Costa's message of "Fri, 27 Jun 2008 18:34:22 -0300")
Message-ID: <87ej6hpxoe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Jun 2008 12:03:21.0725 (UTC) FILETIME=[F5D9AAD0:01C8D916]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <gcosta@redhat.com> writes:

> clobber it in the inline asm macros, and let the compiler do this for us.

I would expect that definitely will cause code size regressions ...

-Andi
