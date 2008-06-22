Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYFVVbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYFVVbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYFVVbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:31:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYFVVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:31:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: Oops when using growisofs
Date: Sun, 22 Jun 2008 23:31:29 +0200
User-Agent: KMail/1.9.9
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>
References: <200806221818.24372.mb@bu3sch.de> <200806222322.05706.arnd@arndb.de>
In-Reply-To: <200806222322.05706.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806222331.29691.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+0f1HiZUeA8B+nsYBDDt2RpxK/c5OeFDkin4W
 l1A+h7zOElTdXnW+S3gt/LBWhgLIoZGJwrzoC3J3pYdiu4Zl3I
 /JBhdrIzqJJdOb2DhBIWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 June 2008, Arnd Bergmann wrote:

> Evidently, alloc_page_buffers got an out of memory condition, which was not caught
> by create_empty_buffers. No idea how it should be handled, but the fact that it's
> not looks like a bug to me ;-).

Oh, btw: http://www.kerneloops.org/search.php?search=create_empty_buffers&btnG=Function+Search
finds 15 more instances of the same bug (and one other bug), across lots of
kernel versions and architectures. The bug has been there since we started
using git.

	Arnd <><
