Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbXLZR1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbXLZR1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 12:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXLZR1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 12:27:39 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:33927 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXLZR1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 12:27:38 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] sleepy linux
Date: Wed, 26 Dec 2007 18:28:04 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071225230731.GA29030@elf.ucw.cz>
In-Reply-To: <20071225230731.GA29030@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712261828.04671.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. Dezember 2007 00:07:31 schrieb Pavel Machek:
> Heute 00:07:31
>    
> This is RFC. It does not even work for me... it sleeps but it will not
> wake up, because SATA wakeup code is missing. Code attached for illustration.
> 
> I wonder if this is the right approach? What is right interface to the
> drivers?

IMHO you are making to many special cases. The system can be "sleepy"
if all devices can be runtime suspended and all CPUs are idle.

	Regards
		Oliver

