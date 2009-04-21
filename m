Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZDUN7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZDUN7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZDUN7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:59:46 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45612 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZDUN7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:59:45 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: lockdep report at resume
Date: Tue, 21 Apr 2009 15:59:41 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input" <linux-input@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>
References: <1234022517.4175.107.camel@johannes.local> <1238578840.5970.178.camel@johannes.local> <alpine.LNX.2.00.0904211550280.13028@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0904211550280.13028@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211559.43497.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 21 April 2009 15:51:16 schrieb Jiri Kosina:
> [ thanks for the analysis Johannes ... involving also Oliver here; really
>   seems like a false positive to me ]

I think he's right. But as a matter of principle I'd like to see 
flush_scheduled_work() avoided where possible, hence the patch.

	Regards
		Oliver

