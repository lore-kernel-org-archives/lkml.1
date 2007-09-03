Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbXICKLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbXICKLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbXICKLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:11:13 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33714 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238AbXICKLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:11:10 -0400
Message-ID: <46DBDEFF.4030206@bull.net>
Date: Mon, 03 Sep 2007 12:16:31 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com
Subject: Re: [RFC][PATCH 1/6] Storing ipcs into IDRs
References: <20070831112445.976429000@bull.net>	<20070831112613.552219000@bull.net> <p73tzqevxue.fsf@bingen.suse.de>
In-Reply-To: <p73tzqevxue.fsf@bingen.suse.de>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 03/09/2007 12:16:38,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 03/09/2007 12:16:40,
	Serialize complete at 03/09/2007 12:16:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Nadia.Derbey@bull.net writes:
> 
> 
>>This patch introduces ipcs storage into IDRs. The main changes are:
>>  . This ipc_ids structure is changed: the entries array is changed into a
>>    root idr structure.
>>  . The grow_ary() routine is removed: it is not needed anymore when adding
>>    an ipc structure, since we are now using the IDR facility.
>>  . The ipc_rmid() routine interface is changed:
>>       . there is no need for this routine to return the pointer passed in as
>>         argument: it is now declared as a void
>>       . since the id is now part of the kern_ipc_perm structure, no need to
>>         have it as an argument to the routine
>>
> 
> 
> Thanks for doing this work. It was long overdue.
> 
> Do you have any data how this changes memory consumption with 
> many objects? 
> 

No. Will try to send you this as soon as I've done some measurements.

Regards,
Nadia


-- 
===============================================================
Name.......... Nadia DERBEY
Organization.. BULL/DT/OSwR&D/Linux
---------------------------------------------------------------
Email......... mailto:Nadia.Derbey@bull.net
Address....... BULL, B.P. 208, 38432 Echirolles Cedex, France
Tel........... (33) 76 29 77 62 [Internal Bull: (229) 77 62]
Telex,Fax..... 980648 F - (33) 76 29 76 00
Internal Bull. Mail: FREC-B1405
===============================================================

