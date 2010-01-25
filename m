Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117Ab0AYS2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0AYS2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699Ab0AYS2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:28:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab0AYS2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:28:02 -0500
Message-ID: <4B5DE2A9.4030500@redhat.com>
Date: Mon, 25 Jan 2010 19:27:53 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Lightning/1.0b1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Marti Raudsepp <marti@juffo.org>
CC: =?ISO-8859-1?Q?=22Ing=2E_Daniel_Rozsny=F3=22?= <daniel@rozsnyo.com>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: bio too big - in nested raid setup
References: <4B5C963D.8040802@rozsnyo.com> <5ec358371001250725l40b13060md880001c96be165f@mail.gmail.com>
In-Reply-To: <5ec358371001250725l40b13060md880001c96be165f@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 04:25 PM, Marti Raudsepp wrote:
> 2010/1/24 "Ing. Daniel Rozsnyó" <daniel@rozsnyo.com>:
>> Hello,
>>  I am having troubles with nested RAID - when one array is added to the
>> other, the "bio too big device md0" messages are appearing:
>>
>> bio too big device md0 (144 > 8)
>> bio too big device md0 (248 > 8)
>> bio too big device md0 (32 > 8)
> 
> I *think* this is the same bug that I hit years ago when mixing
> different disks and 'pvmove'
> 
> It's a design flaw in the DM/MD frameworks; see comment #3 from Milan Broz:
> http://bugzilla.kernel.org/show_bug.cgi?id=9401#c3

Hm. I don't think it is the same problem, you are only adding device to md array...
(adding cc: Neil, this seems to me like MD bug).

(original report for reference is here http://lkml.org/lkml/2010/1/24/60 )

Milan
--
mbroz@redhat.com
