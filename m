Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYCNLIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYCNLIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYCNLIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:08:25 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:57139 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbYCNLIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:08:24 -0400
Message-ID: <47DA5C8D.2020207@emc.com>
Date: Fri, 14 Mar 2008 07:07:57 -0400
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benny Amorsen <benny+usenet@amorsen.dk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz>
In-Reply-To: <20080314093019.GA5966@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.51425
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> Everyone who has write cache turned on for their hard drives is
>>> running in a mode similar to ramback anyway (except for when the file
>>> system is set to force writes to the platter, but that is rare).
>>> Admittedly, software crashes rarely cause the write cache to be lost,
>>> but hardware failures do, practically every time.
>> On the contrary - the hard disk cache is managed by the barrier logic in
>> the kernel, and the ordering even on failures is fairly predictable.
> 
> Well, not even all modern hdds support barriers... It would be really
> nice to have _safe_ settings by default here...
> 

The only really safe default is to disable the write cache by default or 
possibly dynamically disable the write cache when barriers are not 
supported by a drive. Both have a severe performance impact and I am not 
sure that for most casual users it is a good trade.

ric
