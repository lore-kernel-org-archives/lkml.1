Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbYDBQKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbYDBQKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbYDBQJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:09:59 -0400
Received: from rtr.ca ([76.10.145.34]:4660 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbYDBQJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:09:58 -0400
Message-ID: <47F3AFD5.9080801@rtr.ca>
Date: Wed, 02 Apr 2008 12:09:57 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: stern@rowland.harvard.edu, pavel@suse.cz, oliver@neukum.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@suse.cz,
       gregkh@suse.de, akpm@linux-foundation.org
Subject: Re: 2.6.25-rc7:  Ugh.
References: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org> <20080402160414.25F3035F5F8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20080402160414.25F3035F5F8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>> Also, check out the thread on LKML started by Tino Keitel.  He had
>> similar problems and found that reverting commit
>> e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 fixed them.
> 
> And try the change I suggested there:  taking the
> HC_IS_RUNNING test out of ehci_iaa_watchdog().
..

Will do, thanks.  And there's a similar one in ehci_work().  ??
