Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYHFNy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYHFNy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYHFNyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:54:50 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:54941 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbYHFNyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:54:49 -0400
Message-ID: <44710.166.70.238.45.1218029625.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <48995C47.6020808@s5r6.in-berlin.de>
References: <57474.166.70.238.45.1217815846.squirrel@webmail.wolfmountaingroup.com>
    <48995C47.6020808@s5r6.in-berlin.de>
Date: Wed, 6 Aug 2008 07:33:45 -0600 (MDT)
Subject: Re: [PATCH 2.6.26 4/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> jmerkey@wolfmountaingroup.com wrote on 2008-08-04:
>> +ULONG displayASCTable(BYTE *cmd,
>> +		     StackFrame *stackFrame, ULONG Exception,
>> +		     DEBUGGER_PARSER *parser)
>> +{
>> +
>> +     if (cmd) {};
>> +     if (stackFrame) {};
>> +     if (Exception) {};
>> +     if (parser) {};
>> +
>> +     DisplayASCIITable();
>> +     return TRUE;
>> +
>> +}
>
> Hmm, this construct of empty conditional blocks is new to me.  What is
> its purpose?
> --
> Stefan Richter
> -=====-==--- =--- --==-
> http://arcgraph.de/sr/
>

Gets rid of noisy compiler warnings under M$ Windows compilers -- not
needed in linux -- can be removed.

Jeff

