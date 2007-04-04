Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbXDDXzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbXDDXzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXDDXzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:55:54 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:62490 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbXDDXzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IuHBfnEdLCZ7KXhXJ3/91fCiYTKcoshhR6QwM71swPIYPX1TcuUpuxr3c9sPc+pqRA1/Z83XHCY8klgsJn8O06SS8eyRi8rmx8uTEkkLfPdRCU4wiwi33Cy6LkAJHmf33SX31A8mmsrTxpQaj+KlTLffNY6GcgS8VNOuLAHTA2I=
Subject: Re: 2.6.21-rc5-mm4
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200704050838.46032.kernel@kolivas.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175723795.4014.6.camel@daplas>
	 <20070404151027.29dfec58.akpm@linux-foundation.org>
	 <200704050838.46032.kernel@kolivas.org>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 07:55:42 +0800
Message-Id: <1175730942.3981.0.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 08:38 +1000, Con Kolivas wrote:
> On Thursday 05 April 2007 08:10, Andrew Morton wrote:
> > Thanks - that'll be the CPU scheduler changes.
> >
> > Con has produced a patch or two which might address this but afaik we don't
> > yet have a definitive fix?
> >
> > I believe that reverting
> > sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.pat
> >ch will prevent it.
> 
> I posted a definitive fix which Michal tested for me offlist. Subject was:
>  [PATCH] sched: implement staircase deadline cpu scheduler improvements fix
> 
> Sorry about relative noise prior to that. Akpm please pick it up.
> 
> Here again just in case.
> 

Rebooted a few times, I can confirm that this patch fixes this.

Thanks

Tony


