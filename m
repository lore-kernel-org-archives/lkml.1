Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZKZWby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZKZWby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 17:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZKZWbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 17:31:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51803 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZWbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 17:31:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xtv0jV+oj88tzZ54qeYDjfIBOf0g85cwECQlAY55JHMOdy3Oplkl9mefWSgylzWP8q
         /Yl1XS/vy8aXl6F4KauoIexabx4gpP/ba4+gEAatcu2c37u6E5itrNBvK1hcX6SrIabc
         lN0IbfZMvzgibbFQuD56+PYAyzR4VuH6qc96c=
Date: Thu, 26 Nov 2009 23:31:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace_syscalls: add missed field
Message-ID: <20091126223153.GA7177@nowhere>
References: <4B0E330D.1070206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0E330D.1070206@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 03:49:33PM +0800, Lai Jiangshan wrote:
> 
> Field syscall number is missed in syscall_enter_define_fields()/
> syscall_exit_define_fields().
> 
> syscall number is also needed for event filter or other users.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>



Well, I don't think it's very useful for in-kernel filtering.
Filtering a syscall event by its number would mean filtering all
event for this syscall. This is the same as not tracing it.

Or do you have other usecases in mind?

Thanks.

