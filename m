Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbXGJGl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbXGJGl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXGJGlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:41:19 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:10924 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbXGJGlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:41:18 -0400
Message-ID: <469329CD.1040505@openvz.org>
Date: Tue, 10 Jul 2007 10:40:13 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 1/16] Round up the API
References: <468DF6F7.1010906@openvz.org> <468DF745.6070705@openvz.org> <46929819.3030205@fr.ibm.com>
In-Reply-To: <46929819.3030205@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> Pavel Emelianov wrote:
>> The set of functions process_session, task_session, process_group
>> and task_pgrp is confusing, as the names can be mixed with each other
>> when looking at the code for a long time.
>>
>> The proposals are to
>> * equip the functions that return the integer with _nr suffix to
>>   represent that fact,
>> * and to make all functions work with task (not process) by making
>>   the common prefix of the same name.
>>
>> For monotony the routines signal_session() and set_signal_session()
>> are replaced with task_session_nr() and set_task_session(), especially
>> since they are only used with the explicit task->signal dereference.
>>
>> Signed-off-by: Pavel Emelianov <xemul@openvz.org>
>> Acked-by: Serge E. Hallyn <serue@us.ibm.com>
> 
> please let's get that one in. 
> 
> I think we are all ok with it. right ?

Right. That's already the 3rd time I send it to Andrew...

> C.
> 

