Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbXLFHAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbXLFHAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 02:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXLFHAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 02:00:05 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36367 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbXLFHAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 02:00:04 -0500
Message-ID: <47579DEB.9020102@davidnewall.com>
Date: Thu, 06 Dec 2007 17:29:55 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Renzo Davoli <renzo@cs.unibo.it>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <2BD0AF2A-959D-4744-9D2A-3AE84CF96CBB@mac.com>
In-Reply-To: <2BD0AF2A-959D-4744-9D2A-3AE84CF96CBB@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Dec 06, 2007, at 00:30:16, Renzo Davoli wrote:
>> AF_IPN is different.  AF_IPN is the broadcast and peer-to-peer 
>> extension of AF_UNIX. It supports communication among *user* processes.
>
> Ok, you say it's different, but then you describe how IP unicast and 
> broadcast work.

Renzo also described something new (in the socket() arena): the 
multi-reader, multi-writer is just not available in IP.

I wonder if this solves the same problem as d-bus?


> So if you really think this is something that belongs in the kernel 
> you need to provide much more detailed descriptions and use-cases for 
> why it cannot be implemented in user-space or with small modifications 
> to existing UDP/TCP networking. 

I would strengthen this sentiment: If you think something belongs in the 
kernel, you need to argue your case (provide much more detailed 
descriptions and use-cases.)
