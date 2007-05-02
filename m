Return-Path: <linux-kernel-owner+w=401wt.eu-S1766752AbXEBXAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766752AbXEBXAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767184AbXEBXAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:00:14 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35637 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766752AbXEBW74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:59:56 -0400
Message-ID: <463917DD.8020500@zytor.com>
Date: Wed, 02 May 2007 15:59:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <Pine.LNX.4.61.0705022017360.18504@yvahk01.tjqt.qr> <4638FBB8.4020506@zytor.com> <4638FDA6.9030500@gmail.com> <4638FF70.8020400@zytor.com> <46390086.2030904@gmail.com> <463901C9.7090107@zytor.com> <46390503.1000401@gmail.com> <46390CA3.5030300@zytor.com> <46391590.8080209@gmail.com>
In-Reply-To: <46391590.8080209@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 05/03/2007 12:11 AM, H. Peter Anvin wrote:
> 
>> The problem is to detect the ones that have it from the ones that don't.
> 
> Checking here, and mine also has 132x25 as BIOS mode 0x14 in addition to
> 0x55. Probably also not universal, and 0x54 (132x43) doesn't seem to be
> repeated. Unfortunate that Qemu/Bocks don't have the VESA text modes.
> 

Does it export these modes though the VESA interface, or do you have to
"select them blind?"

	-hpa
