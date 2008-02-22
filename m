Return-Path: <linux-kernel-owner+w=401wt.eu-S1764560AbYBVEe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764560AbYBVEe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYBVEeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:34:18 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:36579 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752864AbYBVEeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:34:17 -0500
Message-ID: <47BE4FB5.5040902@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2008 09:59:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: menage@google.com
CC: akpm@linux-foundation.org, xemul@openvz.org, balbir@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] ResCounter: Use read_uint in memory controller
References: <20080221203518.544461000@menage.corp.google.com> <20080221205525.349180000@menage.corp.google.com>
In-Reply-To: <20080221205525.349180000@menage.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> Update the memory controller to use read_uint for its
> limit/usage/failcnt control files, calling the new
> res_counter_read_uint() function.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Hi, Paul,

Looks good, except for the name uint(), can we make it u64(). Integers are 32
bit on both ILP32 and LP64, but we really read/write 64 bit values.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
