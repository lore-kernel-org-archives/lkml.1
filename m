Return-Path: <linux-kernel-owner+w=401wt.eu-S934275AbYAaQxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275AbYAaQxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934177AbYAaQw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:52:58 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11141 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933417AbYAaQw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:52:56 -0500
Message-ID: <47A1FCD8.6050906@panasas.com>
Date: Thu, 31 Jan 2008 18:52:40 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: =?ISO-8859-1?Q?Sven_K=F6hler?= <skoehler@upb.de>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] GDTH driver not working after upgrade to 2.6.24
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47A1ABF8.4050408@upb.de> <47A1C0A5.7090303@panasas.com> <Pine.LNX.4.64.0801311736110.4864@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801311736110.4864@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jan 2008 16:52:43.0186 (UTC) FILETIME=[B289A120:01C86429]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31 2008 at 18:39 +0200, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> Hi,
> 
> On Jan 31 2008 14:35, Boaz Harrosh wrote:
>> Thanks, Perhaps someone else then. 
>> Anyone with gdth HW that can test patches?
> 
> Is bisecting down the existing chain and finding the bad commit 
> sufficient? (I also take new patches.)
Most certainly. If you are willing, please... I'm looking for someone
responsive.

first -  enable debug prints (see the original post)
         and send me the prints.
second - bisection could be grate yes.
third - accepting patches and testing could be grate, thanks.

> 
>> Your lspci said: "Intel Corporation RAID Controller" Matthew
>> is there a gdth card lying around in an Intel lab near you?
>>
>> James do we need to mark gdth BROKEN for 2.6.24 and higher?
> 
> I say revert it for the time being.

It could be reverted for 2.6.24.x  maintenance releases but for 2.6.25-xxx
it cannot as it will not compile, and the fix to that is what you see in code.

Boaz
