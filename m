Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXCMQAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXCMQAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbXCMQAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:00:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47667 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbXCMQAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:00:06 -0400
Date: Tue, 13 Mar 2007 21:37:07 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/7] Resource counters
Message-ID: <20070313160707.GF19939@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <45ED7DEC.7010403@sw.ru> <45ED7F69.60108@sw.ru> <45EE39A5.7010804@in.ibm.com> <45EE6769.9060701@sw.ru> <20070309163711.GA3647@MAIL.13thfloor.at> <m1fy8bwqps.fsf@ebiederm.dsl.xmission.com> <20070312011612.GD21861@MAIL.13thfloor.at> <m1bqixtsr1.fsf@ebiederm.dsl.xmission.com> <20070313152150.GK8755@MAIL.13thfloor.at> <45F6C611.7070400@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6C611.7070400@sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 06:41:05PM +0300, Pavel Emelianov wrote:
> > right, but atomic ops have much less impact on most
> > architectures than locks :)
> 
> Right. But atomic_add_unless() is slower as it is
> essentially a loop. See my previous letter in this sub-thread.

If I am not mistaken, you shouldn't loop in normal cases, which means
it boils down to a atomic_read() + atomic_cmpxch()


-- 
Regards,
vatsa
