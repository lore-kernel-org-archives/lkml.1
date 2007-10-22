Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbXJVLyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbXJVLyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXJVLyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:54:47 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:34053 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbXJVLyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:54:46 -0400
Message-ID: <471C8ED4.7080400@aitel.hist.no>
Date: Mon, 22 Oct 2007 13:51:48 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about free/used memory on Linux
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com> <471BA1D1.5040905@linux.vnet.ibm.com> <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847C@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847C@xmb-sjc-214.amer.cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ravinandan Arakali (rarakali) wrote:
> Hi Vaidy,
> Thanks for clarifying several of my doubts.
>
> To answer your question about my intention, we currently have a 
> system with 2 GB RAM and I need to find out the actual used and 
> free memory so that we can decide if the same setup(applications,
> tmpfs etc.) can run on another system with lesser memory.
>   
You can test this directly.
Boot your 2G machine with
mem=<size of smaller system>
Then the machine uses less memory, you get
a realistic test of how the smaller machine will
perform.


Helge Hafting
