Return-Path: <linux-kernel-owner+w=401wt.eu-S932888AbXCABQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbXCABQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 20:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932889AbXCABQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 20:16:28 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:16009 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888AbXCABQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 20:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CBZRJBMNHrlDv3oSfckxnkRogxySyVqBDMEiApJq1olz3ieUGtkL4hNvSHPOn3C/AJgNNYL/saf0YasKN72FvnvRWp3mZRT4qP83GzgwR8EJ1kkETTUAy6OPTrFDURYk9dayLBJeQhEVxwdL12sYXq1ZsP7kCRZm1rbACMPLRR4=
Message-ID: <787b0d920702281716x76d57c8fm76f4e7a8c0e675d@mail.gmail.com>
Date: Wed, 28 Feb 2007 20:16:24 -0500
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PID entries in /proc sorted by number, not start time in 2.6.19
Cc: "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <m1irdlg8cg.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45E601D9.1050503@redhat.com>
	 <m1irdlg8cg.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Chuck Ebbert <cebbert@redhat.com> writes:
>
> > Starting with kernel 2.6.19, the process directories in
> > /proc are sorted by number. They were sorted by process
> > start time in 2.6.18 and earlier. This makes the output
> > of procps come out in that order too, pissing off users
> > who are used to the old way.

ps --sort=start_time

I've always just assumed the order to be random.
