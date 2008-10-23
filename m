Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYJWTAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYJWTAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbYJWTAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:00:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43509 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbYJWTAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:00:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4900C9A9.7010104@s5r6.in-berlin.de>
Date: Thu, 23 Oct 2008 20:59:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: Possible bug in SCSI Kconfig
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com> <1224702340.6851.20.camel@localhost.localdomain> <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com> <1224704659.6851.28.camel@localhost.localdomain> <4900B4B9.4050103@s5r6.in-berlin.de> <20081023173917.GP26094@parisc-linux.org>
In-Reply-To: <20081023173917.GP26094@parisc-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Oct 23, 2008 at 07:30:33PM +0200, Stefan Richter wrote:
>>   - scsi_wait_scan is a special method to wait for devices during boot
>>     which only works with some hardware types.  More general methods are
>>     available and have been in use far longer than scsi_wait_scan
>>     exists.  Nobody fundamentally needs scsi_wait_scan, it is only a
>>     convenient tool for some users who choose to use it.
>>     Special features are traditionally per default off in Kconfig and
>>     are supposed to be actively enabled.
> 
> What 'general methods' would those be?

Waiting for the desired numbers of devices to show up.  Or for a known 
device.

scsi_wait_scan is optimal though if it is known at the outset how many 
devices (or how many at maximum) will show up.
-- 
Stefan Richter
-=====-==--- =-=- =-===
http://arcgraph.de/sr/
