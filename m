Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYGVKqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYGVKqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYGVKpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:45:50 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:54953 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYGVKpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:45:49 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: 2.6.22: USB getting stuck on SuperMicro PDSME+ boards
Date: Tue, 22 Jul 2008 12:46:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, nikola.ciprich@linuxbox.cz,
       linux-usb@vger.kernel.org
References: <20080722074357.GC21035@develbox.linuxbox.cz> <200807220948.28649.oliver@neukum.org> <20080722084710.GD21035@develbox.linuxbox.cz>
In-Reply-To: <20080722084710.GD21035@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221246.37495.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 22 Juli 2008 10:47:10 schrieb Nikola Ciprich:
> Hi Olivirier,
> 
> thanks for reply. I know it would be best to try 2.6.26, but that's what
> I can't do. So I'd like to find if the problem was already fixed, and 
> if it was, then to backport the fix to our kernel. And if it wasn't, then to fix
> it even for 2.6.27 :)

That points to sysfs. A lot of fixes have gone into it. Trying 2.6.26 would
be the best option. If it is an AB-BA deadlock you can recompile the kernel
with lockdep.

	Regards
		Oliver
