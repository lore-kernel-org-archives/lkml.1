Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZJPFnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZJPFnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 01:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZJPFm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 01:42:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbZJPFm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 01:42:59 -0400
Message-ID: <4AD807A3.6060508@zytor.com>
Date: Thu, 15 Oct 2009 22:41:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
       rjw@sisk.pl, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de> <20091014045851.GA32413@core.coreip.homeip.net> <20091014071950.GF23248@one.firstfloor.org> <20091014073927.GB5318@core.coreip.homeip.net>
In-Reply-To: <20091014073927.GB5318@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 12:39 AM, Dmitry Torokhov wrote:
> On Wed, Oct 14, 2009 at 09:19:50AM +0200, Andi Kleen wrote:
>>> Btw, what kind of keyboard is this? I was playing today but I could not
>>> get my USB keyboards to report release of more than 1 key per report....
>>
>> The log was with a PS/2<->USB adapter, with a PS/2 keyboard connected
>> to a USB port through it.
>>
> 
> Hmm, I don't think I have one of those... It is curious beast - we have
> software autorepeat for HID but PS/2 keyboards do autorepeat
> themselves... What will combination do?
> 

Autorepeat on PS/2 keyboards is a mode setting.  I would guess the HID
adapter would turn it off if it is halfway sane.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

