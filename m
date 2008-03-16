Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYCPNK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYCPNK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 09:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYCPNKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 09:10:50 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:43308 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYCPNKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 09:10:49 -0400
From: Chr <chunkeey@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc5-git5: Reported regressions from 2.6.24
Date: Sun, 16 Mar 2008 14:10:46 +0100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803160112.50874.rjw@sisk.pl>
In-Reply-To: <200803160112.50874.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803161410.46977.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+1kSbZfAhKEAJLrTTRngqRu1RmhfGgi+5yQyU7
	EqcpBZXwm2aZsYTHNOPA33qKDkEvdec1/HZZyRYylM0CLmVeIe
	igojjGDKo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008 01:12:50 Rafael J. Wysocki wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10207
> Subject         : INFO: task mount:11202 blocked for more than 120 seconds
> Submitter       : Christian Kujau <lists@nerdbynature.de>
> Date            : 2008-03-07 21:32 (9 days old)
> References      : http://lkml.org/lkml/2008/3/7/308
>                   http://lkml.org/lkml/2008/3/9/186

well, there's another bug-entry about the same problem there: 
http://bugzilla.kernel.org/show_bug.cgi?id=10242

can you anyhow merge these two? (because the other one contains
some patches (unfortunately not final) )

a good workaround for now, one can revert the following commit:

commit  3a7f6c990ad04e6f576a159876c602d14d6f7fef
dm crypt: use async crypto

dm-crypt: Use crypto ablkcipher interface
Move encrypt/decrypt core to async crypto call.


Regards,
	Chr.
