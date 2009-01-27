Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZA0RQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZA0RQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbZA0ROM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:14:12 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:57665 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261AbZA0ROK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:14:10 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc2 dies on startup
References: <877i4rjw38.fsf@tac.ki.iif.hu>
	<20090125224625.96429d3d.akpm@linux-foundation.org>
	<d6200be20901261629y2e3d8804h16055b9497125371@mail.gmail.com>
Date: Tue, 27 Jan 2009 18:13:58 +0100
In-Reply-To: <d6200be20901261629y2e3d8804h16055b9497125371@mail.gmail.com>
	(Arve =?utf-8?B?SGrDuG5uZXbDpWcncw==?= message of "Mon, 26 Jan 2009
 16:29:55 -0800")
Message-ID: <87y6wwisdl.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg <arve@android.com> writes:

> On Sun, Jan 25, 2009 at 10:46 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>
>> At a guess I'd say that drivers/staging/android/ram_console.c is calling
>> the reed-solomon code earlier than it's expecting.  But that might be
>> totally wrong.
>
> Yes, but it also is trying to use a zero sized buffer at virtual
> address 0 so it will not work much better if you turn off ecc.

This sounds understandable given that the defaults are

CONFIG_ANDROID_RAM_CONSOLE_EARLY_ADDR=0x0
CONFIG_ANDROID_RAM_CONSOLE_EARLY_SIZE=0x0

> This patch (to the android kernel tree) add some validation:

Compiling it now (on the vanilla tree).
-- 
Regards,
Feri.
