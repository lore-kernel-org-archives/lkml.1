Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbYJTMP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbYJTMP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJTMPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:15:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:16967 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbYJTMPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:15:09 -0400
From: Andrey Mirkin <major@openvz.org>
To: devel@openvz.org
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
Date: Mon, 20 Oct 2008 16:14:35 +0400
User-Agent: KMail/1.8.2
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Pavel Emelyanov <xemul@openvz.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1224286383.1848.65.camel@nimitz>
In-Reply-To: <1224286383.1848.65.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201614.36911.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 October 2008 03:33 Dave Hansen wrote:
> On Wed, 2008-09-03 at 14:57 +0400, Andrey Mirkin wrote:
> > This patchset introduces kernel based checkpointing/restart as it is
> > implemented in OpenVZ project. This patchset has limited functionality
> > and are able to checkpoint/restart only single process. Recently Oren
> > Laaden sent another kernel based implementation of checkpoint/restart.
> > The main differences between this patchset and Oren's patchset are:
>
> Hi Andrey,
>
> I'm curious what you want to happen with this patch set.  Is there
> something specific in Oren's set that deficient which you need
> implemented?  Are there some technical reasons you prefer this code?

Hi Dave,

Right now my patchset (v2) provides an ability to checkpoint and restart a 
group of processes. The process of checkpointing and restart can be initiated 
from external process (not from the process which should be checkpointed).
Also I think that all the restart job (including process forking) should be 
done in kernel, as in this case we will not depend on user space and will be 
more secure. This is also implemented in my patchset.

Andrey
