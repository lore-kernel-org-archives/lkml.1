Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab0BQQoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:44:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:31709 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0BQQoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:44:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DJL09SuBBOyPLL6fOD2LpgHU7xQLNRBqfwgCZUZ1zo97H59gGaabrgcoM8gQxwIIlV
         CD+3at8BXlTNMCH1b+8umumCWLbXCmEh2dESRNI4taITc6SpUBfXnPDuw3fTqAaQte9k
         xmNLkD7l+eJ7vlMaEWIfD1xN/k9EOWleuOukU=
Date: Wed, 17 Feb 2010 17:43:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH perf/core] percpu: add __percpu sparse annotations to
	trace
Message-ID: <20100217164354.GD5041@nowhere>
References: <4B7B5169.50502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7B5169.50502@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 11:16:09AM +0900, Tejun Heo wrote:
> Add __percpu sparse annotations to trace.
> 
> These annotations are to make sparse consider percpu variables to be
> in a different address space and warn if accessed without going
> through percpu accessors.  This patch doesn't affect normal builds.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

