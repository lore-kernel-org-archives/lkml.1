Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492AbZG1ExD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbZG1ExD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZG1ExC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:53:02 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:50333 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZG1ExA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:53:00 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Add function to convert between calendar time and broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com>
	<20090714151040.b7b3b26d.akpm@linux-foundation.org>
	<20090718115019.GH1433@ucw.cz>
	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>
	<20090719202018.497f7ec1.akpm@linux-foundation.org>
	<4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com>
	<87ocr9mi8h.fsf@devron.myhome.or.jp>
	<20090727224432.GB7142@elf.ucw.cz>
Date: Tue, 28 Jul 2009 13:52:55 +0900
In-Reply-To: <20090727224432.GB7142@elf.ucw.cz> (Pavel Machek's message of
	"Tue, 28 Jul 2009 00:44:32 +0200")
Message-ID: <87zlap9zo8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

>> Why isn't this "long"? "int" can overflow.
>
> Overflow? Year?
>
> I'm not sure how far ahead you are looking, but support for year
> 2000000000 (2e9) seems perfectly okay to me. (Our friendly star here,
> sun, is going to die at cca year 5e9, for comparison. )

Yes. If source is guaranteed as only xtime, but I'd like to think all
case. Especially, because this is library.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
