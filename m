Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYBDNwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYBDNwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYBDNwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:52:24 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44412 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYBDNwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:52:23 -0500
Message-ID: <47A71891.3010902@bull.net>
Date: Mon, 04 Feb 2008 14:52:17 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2.6.24-rc8-mm1 00/15] IPC: code rewrite + new functionalities
References: <20080129160229.612172683@bull.net> <20080202182351.GC4456@ucw.cz>
In-Reply-To: <20080202182351.GC4456@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Pavel Machek wrote:
> Hi!
> 
>> * Patches 9 to 15 propose to add some functionalities, and thus are
>> submitted here for RFC, about both the interest and their implementation.
>> These functionalities are:
>>     - Two new control-commands:
>> 	. IPC_SETID: to change an IPC's id.
>> 	. IPC_SETALL: behaves as IPC_SET, except that it also sets all time
>> 	  and pid values)
>>     - add a /proc/<pid>/semundo file to read and write the undo values of
>> some semaphores for a given process.
>>
>> 	As the namespaces and the "containers" are being integrated in the
>> kernel, these functionalities may be a first step to implement  the
>> checkpoint/restart of an application: in fact the existing API does not allow
>> to specify or to change an ID when creating an IPC, when restarting an
>> application, and the times/pids values of each IPCs are also altered. May be
>> someone may find another interest about this ?
>>
>> So again, comments are welcome.
> 
> Checkpoint/restart is nice, but... sysV ipc is broken by design, do we
> really want to extend it?

If we want to support all kind of applications, yes, we must also support
SysVipc. We must support all kernel subsystems at the end.
I've started with IPC, because it's relatively simple and isolated.


-- 
Pierre
