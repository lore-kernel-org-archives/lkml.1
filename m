Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953Ab0AEP4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0AEP4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711Ab0AEP43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:56:29 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:62458 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab0AEP42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:56:28 -0500
Message-ID: <4B43602F.1050202@nortel.com>
Date: Tue, 05 Jan 2010 09:52:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Nobin Mathew <nobin.mathew@gmail.com>
CC: Shivdas Gujare <shivdas.tech@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: init_task belongs to "process 0" or "process 1"?
References: <cf70f0211001040007s5be9f1aas7bb52928c8d50e7c@mail.gmail.com> <8d6898731001042332m6b5b97b0n5515ae166f62aad2@mail.gmail.com>
In-Reply-To: <8d6898731001042332m6b5b97b0n5515ae166f62aad2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2010 15:56:21.0703 (UTC) FILETIME=[A03E0570:01CA8E1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 01:32 AM, Nobin Mathew wrote:
> init_task is the head of doubly linked list which holds all
> task_structs in the system. init_task is again the task_struct for
> process 0/swapper/idle task. This process is created manually (I meant
> to say not by copy_process() calls). Manually means they are static
> structures defined in the code (see INIT_TASK, init_mm, init_fs etc).
> There will be multiple idle task if there is more than 1 cpu core.
> Idle task is the one which is scheduled if there is no other task
> ready for scheduling.
> 
> Init task is process 1 which is initially a kernel thread created from
> process 0 using copy_process(), then it does an execv() (/sbin/init )
> or similar one to create the normal process init.
> 
> Name given to process 0 is swapper.
> .comm           = "swapper"

Oddly enough, this name makes no sense anymore.  Why don't we call
process 0 "idle"?

Chris
