Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXFZJIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXFZJIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXFZJIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:08:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:10732 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbXFZJIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cb7I0E6uTtYy6OhAvO1rQG+GFSQmVFKTYe5hNK8pKxYhuXmU5xXBEstH7zf9C6U/90fUnz0WrtXOOK6ayMvhXCzQo3IE7EJbjMpRSNrG+uSnAHL6n3hLkMKksKh6m/E8m0F43fRMpa9EKSrzFJ3D3HTu9BOT5OcPBIqhOf8eFGY=
Message-ID: <a781481a0706260208x678e5e11rdbd163e0e791c3de@mail.gmail.com>
Date: Tue, 26 Jun 2007 14:38:37 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: gshan <gshan@alcatel-lucent.com>
Subject: Re: bugs in __schedule()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4680D48F.6070105@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4680C6F3.9000504@alcatel-lucent.com>
	 <a781481a0706260118o2ef795bj579b3ec86c4fca8a@mail.gmail.com>
	 <4680CC51.1050205@alcatel-lucent.com>
	 <a781481a0706260125l76c5848aq85403a4ec94d57da@mail.gmail.com>
	 <4680D007.3040007@alcatel-lucent.com>
	 <a781481a0706260150q2c27ddcal9595ebe91ff844c2@mail.gmail.com>
	 <4680D48F.6070105@alcatel-lucent.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
> I mean kernel thread could sleep, but tasklet can't. If so, it meet my
> requirements.

That's not really a justification to convert a tasklet to a kernel thread.
I suspect the simplest solution to your problem would be to simply
replace that semaphore with a spinlock. Other than that, we can't really
help without looking at code.
