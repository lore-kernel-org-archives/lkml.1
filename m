Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYCAILR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYCAILR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 03:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYCAILF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:11:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48533 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbYCAILF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:11:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C90F83.3030700@s5r6.in-berlin.de>
Date: Sat, 01 Mar 2008 09:10:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linuxppc-dev@ozlabs.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] firewire: fw-ohci: shut up false compiler warning
 on PPC32
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>	<tkrat.ee238048a5a50184@s5r6.in-berlin.de> <20080301141741.172013ba.sfr@canb.auug.org.au>
In-Reply-To: <20080301141741.172013ba.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> On Sat, 1 Mar 2008 02:50:44 +0100 (CET) Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Wasn't there a macro somewhere for this?
> 
> Yes, uninitialized_var() in linux/compiler*.h

Right.  I actually did look into compiler.h and compiler-gcc.h but 
somehow didn't make it down into -gcc?.h.  Thanks,
-- 
Stefan Richter
-=====-==--- --== ----=
http://arcgraph.de/sr/
