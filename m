Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYF1MJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYF1MJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbYF1MJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:09:50 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:47195 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYF1MJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:09:49 -0400
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 12/39] introduce __ASM_REG macro
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
Date: Sat, 28 Jun 2008 14:09:47 +0200
In-Reply-To: <1214602486-17080-13-git-send-email-gcosta@redhat.com> (Glauber Costa's message of "Fri, 27 Jun 2008 18:34:19 -0300")
Message-ID: <87iqvtpxpw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Jun 2008 12:02:28.0444 (UTC) FILETIME=[D617A1C0:01C8D916]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <gcosta@redhat.com> writes:

> There are situations in which the architecture wants to use the
> register that represents its word-size, whatever it is. For those,
> introduce __ASM_REG in asm.h, along with the first users _ASM_AX
> and _ASM_DX. They have users waiting for it, namely the getuser
> functions.

FYI the ABI of the 64bit get_user was designed for minimal
code size originally.  You should check for regressions if you
change that.

-Andi
