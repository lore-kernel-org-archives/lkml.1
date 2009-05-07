Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZEGNeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZEGNeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZEGNdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:33:51 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:35950 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZEGNdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:33:50 -0400
Message-ID: <4A02E32C.7050606@linux.vnet.ibm.com>
Date: Thu, 07 May 2009 15:33:32 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/4] kernel: constructor support
References: <20090507124556.041286732@linux.vnet.ibm.com>  <20090507124557.003153444@linux.vnet.ibm.com> <20090507125107.GL28398@elte.hu>
In-Reply-To: <20090507125107.GL28398@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> 
>> +typedef void (*ctorcall_t)(void);
> 
> that name is pretty ugly. Please change it to the usual kernel 
> convention for function pointers:
> 
> 	typedef void (*ctor_fn_t)(void);

Ok, will do. Thanks.

