Return-Path: <linux-kernel-owner+w=401wt.eu-S1763988AbZFNUfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763988AbZFNUfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbZFNUf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:35:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763776AbZFNUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:35:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 2/4] asm-generic: uaccess: add missing access_ok() check to strnlen_user()
Date: Sun, 14 Jun 2009 22:35:26 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org> <1244959204-11269-2-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244959204-11269-2-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906142235.26522.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18sUAflqbbrPGPoJKS0JoAJ5UhOrInCog/+mC5
 /EYC948rH9yZXBqTMVapnlj0QXDkV+d/cdyXzhsaIUyKBOr7Nb
 ivnV+2N/qr2n1xKh/Zapg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Mike Frysinger wrote:
> The strnlen_user() function was missing a access_ok() check on the pointer
> given.  We've had cases on Blackfin systems where test programs caused
> kernel crashes here because userspace passed up a NULL/-1 pointer and the
> kernel gladly attempted to run strlen() on it.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied, thanks.

	Arnd <><
