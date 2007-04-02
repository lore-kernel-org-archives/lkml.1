Return-Path: <linux-kernel-owner+w=401wt.eu-S965821AbXDBUTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965821AbXDBUTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965822AbXDBUTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:19:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965821AbXDBUTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:19:05 -0400
Message-ID: <4611652F.700@zytor.com>
Date: Mon, 02 Apr 2007 13:18:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: mathiasen@gmail.com
Subject: A set of "standard" virtual devices?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On the subject of virtualization; there are a number of devices which 
keep being invented and reinvented by just about every virtualization 
vendor for no really good reason.

I personally recently pointed out that a proper virtualization solution 
should handle entropy collection at the lowest level (where the physical 
hardware drivers are) and present a hw_rng interface to the guests. 
Unfortunately, none of the hardware-based hw_rng interfaces is sane 
enough to do that with, which calls for a virtual driver.

It would be nice if there was one, and not a dozen, such drivers.

I would therefore like to propose that the Linux Foundation register a 
PCI ID for use by LANANA ($3000/year), and we set up a LANANA registry 
for these device IDs, together with a description of the device 
interface each of them expect.  Similarly, a Subsystem ID registry can 
be used (for virtualization vendors which don't have their own VID 
already) to distinguish different implementations.

Obviously, anyone who adheres to the published interface can use one of 
these VID:DIDs -- as far as I'm concerned, even hardware vendors; we'll 
use the SID to distinguish between implementations.

	-hpa
