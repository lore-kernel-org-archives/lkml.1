Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYF1MMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYF1MMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYF1MMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:12:40 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:47440 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYF1MMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:12:39 -0400
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 17/39] clobber rbx in putuser_64.S
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
	<1214602486-17080-17-git-send-email-gcosta@redhat.com>
	<1214602486-17080-18-git-send-email-gcosta@redhat.com>
Date: Sat, 28 Jun 2008 14:12:37 +0200
In-Reply-To: <1214602486-17080-18-git-send-email-gcosta@redhat.com> (Glauber Costa's message of "Fri, 27 Jun 2008 18:34:24 -0300")
Message-ID: <87abh5pxl6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Jun 2008 12:05:18.0497 (UTC) FILETIME=[3B73A910:01C8D917]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <gcosta@redhat.com> writes:

> Instead of clobbering r8, clobber rbx, which is the i386 way.

Note rbx is callee saved on 64bit, so using that one means
the surrounding function always has to save explicitely.
Not the case with r8.

There's a reason it is the way it is.

-Andi
