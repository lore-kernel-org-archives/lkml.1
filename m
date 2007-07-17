Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbXGQSM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbXGQSM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935532AbXGQSMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:12:16 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:36419 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935455AbXGQSMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:12:15 -0400
Message-ID: <469D066B.6050606@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2007 23:41:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: =?windows-1252?Q?=22Paul_=28=3F=3F=29_Menage=22?= 
	<menage@google.com>
CC: dhaval@linux.vnet.ibm.com, Pavel Emelianov <xemul@sw.ru>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Paul Jackson <pj@sgi.com>, Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Containers: css_put() dilemma
References: <469BBE00.8000709@linux.vnet.ibm.com> <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com> <469C2792.6050009@linux.vnet.ibm.com> <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com> <20070717070031.GA22410@linux.vnet.ibm.com> <6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com> <469C99D1.7090807@linux.vnet.ibm.com> <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com> <469CFF2B.1080702@linux.vnet.ibm.com> <6599ad830707171044u38c0a940r12d2bc80b475ead4@mail.gmail.com>
In-Reply-To: <6599ad830707171044u38c0a940r12d2bc80b475ead4@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul (??) Menage wrote:
> On 7/17/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>> That sounds correct. I wonder now if the solution should be some form
>> of delegation for deletion of unreferenced containers (HINT: work queue
>> or kernel threads).
> 
> What a great idea. In fact, that's exactly what the release agent
> patch already does.

:-) I should have seen that. I am a little lost thinking that
container_rmdir() and the release agent check_for_release() work
without too much knowledge of each other. BTW, what are the semantics
of css_put() is it expected to free the container/run the release agent
when the reference count of the container_subsys_state drops to zero?
 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
