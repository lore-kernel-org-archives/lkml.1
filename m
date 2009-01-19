Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZASQfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZASQfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZASQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:35:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45148 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZASQfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:35:34 -0500
Message-ID: <4974ABBF.8020600@redhat.com>
Date: Mon, 19 Jan 2009 18:35:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: Avoid using CONFIG_ in userspace visible headers
References: <1232370050-7434-1-git-send-email-avi@redhat.com> <20090119130927.GC6876@elte.hu> <49747C44.1030901@redhat.com> <20090119132214.GA20722@elte.hu> <20090119162947.GA10378@uranus.ravnborg.org>
In-Reply-To: <20090119162947.GA10378@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> With the exported headers we at least have a clear definition
> what part of the headers are actually exported.
> So what we have now is a much better base to cut off from.
>
> And there is plenty of room for improvements but it requires
> someone with understanding of the kernel side and the user side to do
> this.
>
> I for once find it hard to judge what is really used by user space and
> not. Diving into glibc does not help as userspace is much more than
> glibc although glibc is an important 'customer' here.
>   

If you set up an abi directory with clear guidelines and kbuild support, 
actively maintained pieces could be moved by the maintainers.  The rest 
will continue to suck, but we will have improved the kernel a little bit.

-- 
error compiling committee.c: too many arguments to function

