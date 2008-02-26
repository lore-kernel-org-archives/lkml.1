Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbYBZPOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbYBZPOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYBZPOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:14:16 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:35522 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYBZPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:14:14 -0500
Message-ID: <47C40269.7060309@emc.com>
Date: Tue, 26 Feb 2008 07:13:29 -0500
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
References: <20080226072649.GB30238@shareable.org> <47C3C33F.1070908@garzik.org>
In-Reply-To: <47C3C33F.1070908@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.51425
X-PerlMx-Spam: Gauge=, SPAM=0%, Reason='EMC_FROM_0+ -3, DATE_IN_PAST_03_06! 1.5, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jamie Lokier wrote:
>> By durable, I mean that fsync() should actually commit writes to
>> physical stable storage,
> 
> Yes, it should.
> 
> 
>> I was surprised that fsync() doesn't do this already.  There was a lot
>> of effort put into block I/O write barriers during 2.5, so that
>> journalling filesystems can force correct write ordering, using disk
>> flush cache commands.
>>
>> After all that effort, I was very surprised to notice that Linux 2.6.x
>> doesn't use that capability to ensure fsync() flushes the disk cache
>> onto stable storage.
> 
> It's surprising you are surprised, given that this [lame] fsync behavior 
> has remaining consistently lame throughout Linux's history.

Maybe I am confused, but isn't this is what fsync() does today whenever 
barriers are enabled (the fsync() invalidates the drive's write cache).

ric
