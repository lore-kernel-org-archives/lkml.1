Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYBIPnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYBIPnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYBIPn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:43:29 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:12207 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYBIPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:43:28 -0500
Message-ID: <47ADC913.5010202@oracle.com>
Date: Sat, 09 Feb 2008 07:38:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, torvalds@osdl.org,
       linux-input@vger.kernel.org, dtor@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyboard notifier documentation
References: <20080209013322.GC4463@implementation> <20080208201253.46c068ed.randy.dunlap@oracle.com> <20080209114031.GC4379@implementation>
In-Reply-To: <20080209114031.GC4379@implementation>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault wrote:
> Randy Dunlap, le Fri 08 Feb 2008 20:12:53 -0800, a écrit :
>> On Sat, 9 Feb 2008 01:33:22 +0000 Samuel Thibault wrote:
>>> +- 'vc' always provide the VC for which the keyboard event applies ;
>>> +- 'down' is 1 for a key press event, 0 for a key release ;
>>> +- 'shift' is the current modifier state, mask bit indexes are KG_* ;
>> No space before the ';' (3 times).
> 
> Well, as expected in French...  I'll fix that.
> 
>>> +For each kind of event but the last, the callback may return NOTIFY_STOP in
>>> +order to "eat" the event: the notify loop is stopped and the keyboard event is
>>> +dropped.
>>> +
>>> +I a rough C snippet, we have:
>>    In a rough (?)
> 
> Yes, rough as "something that a C compiler will never accept, but that
> you, human, will make sense out of it".

so s/I/In/ please.

-- 
~Randy
