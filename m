Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbXK0Wmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbXK0Wmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbXK0Wmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:42:45 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:20979 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752422AbXK0Wmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:42:44 -0500
Message-ID: <474C9D6A.4000505@cfl.rr.com>
Date: Tue, 27 Nov 2007 17:42:50 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?TWlrYWVsIFN0w6VsZGFs?= <mikael.staldal@univits.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Possibility to adjust the only-root-can-bind-to-port-under-1024
 limit
References: <4742B3A3.2050103@univits.com> <20071120155303.76f234ec@astralstorm.puszkin.org> <474A975A.8020302@univits.com>
In-Reply-To: <474A975A.8020302@univits.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Nov 2007 22:42:59.0708 (UTC) FILETIME=[DC82A3C0:01C83146]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15572.001
X-TM-AS-Result: No--5.317400-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Ståldal wrote:
> And how do you protect ports >1024 from any user binding to them?
> 
> Isn't the 1024 limit somewhat obsolete and arbitrary today?

No, it is not obsolete, yes, it always was arbitrary.

You prevent users from binding to those ports by only giving 
applications that need to the capability, and only letting the users 
that need to have execute permission to those programs.

