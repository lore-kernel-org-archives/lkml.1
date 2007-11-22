Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXKVMD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXKVMD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 07:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXKVMDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 07:03:17 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34859 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbXKVMDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 07:03:16 -0500
Message-ID: <47456FFC.5090806@davidnewall.com>
Date: Thu, 22 Nov 2007 22:33:08 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Ubuntu@bugabundo.net, Ubuntu-reply@bugabundo.net,
       ubuntu-devel-discuss@lists.ubuntu.com, linux-kernel@vger.kernel.org
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
References: <473E815F.30900@minimum.se> <20071116213137.6efe3f9e@the-village.bc.nu> <473E9290.3040006@minimum.se> <200711220005.32569.Ubuntu@bugabundo.net>
In-Reply-To: <200711220005.32569.Ubuntu@bugabundo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(``-_-´´) -- Fernando wrote:
> I used to see stuff like this happening on my University students test servers. Once they started doing forks inside for(;;), the server would go down.
> Then they replaced the servers by vwmare machines, and now reboots are faster.
>   

UNIX (and Linux) already has a feature for use in case of forkbombs, 
namely keeping a shell available, at a high priority, from which you 
manage a wide range of undesired situations.  There isn't, that I know 
of, any program which responds to a magic key and does the work, but I 
think it can be written without requiring any additional kernel support.

