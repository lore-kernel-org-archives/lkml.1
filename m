Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYJBT0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYJBT0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYJBT00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:26:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55354 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbYJBT0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:26:25 -0400
Date: Thu, 2 Oct 2008 15:25:21 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch x86/core] x86: allow number of additional hotplug CPUs
 to be set at compile time
Message-ID: <20081002152521.16c4835b@redhat.com>
In-Reply-To: <87bpy3pdgs.fsf@basil.nowhere.org>
References: <20081001191945.4182d0be@redhat.com>
	<87bpy3pdgs.fsf@basil.nowhere.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Oct 2008 11:12:51 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Chuck Ebbert <cebbert@redhat.com> writes:
> 
> > The default number of additional CPU IDs for hotplugging is determined
> > by asking ACPI or mptables how many "disabled" CPUs there are in the
> > system, but many systems get this wrong so that e.g. a uniprocessor
> > machine gets an extra CPU allocated and never switches to single CPU
> > mode.
> 
> You can set this with additional_cpus=... at boot time.
> I don't think each runtime option needs a CONFIG option too.
> 

Well not all of them, but this one is a good candidate.  Either that or
we should just change the default to zero.
