Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZBJNcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZBJNcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZBJNcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:32:07 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:60329 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZBJNcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:32:06 -0500
Date: Tue, 10 Feb 2009 14:31:58 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       avi@redhat.com, akataria@vmware.com
Subject: Re: [PATCH 2/2] show hypervisor information on sysfs
Message-ID: <20090210143158.056bbd43@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090210132023.GB13577@poweredge.glommer>
References: <1233935217-24090-1-git-send-email-glommer@redhat.com>
	<1233935217-24090-2-git-send-email-glommer@redhat.com>
	<1233935217-24090-3-git-send-email-glommer@redhat.com>
	<20090207114331.49bb30bc@osiris.boeblingen.de.ibm.com>
	<20090210132023.GB13577@poweredge.glommer>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 11:20:23 -0200
Glauber Costa <glommer@redhat.com> wrote:
> > Anyway, just wanted to make you aware of what might come next.
> 
> Why wouldn't it be extensible? So far, I've only added an attribute. But we
> can easily add others, and directories with even more attributes if we must.

Oh, sure it's easily extensible, the question is if the first attribute
you now add will be at the right place. That is: is all information
about the 1st level hypervisor supposed to be found in /sys/hypervisor
or should it be in a subdirectory? E.g. /sys/hypervisor/level1 or
something like that.
But adding your attribute won't hurt. The worst case is that it gets
duplicated.
