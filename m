Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYCLCgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYCLCgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYCLCgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:36:41 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYCLCgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:36:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=K8IEXE+3O9nWOms7TyN6bQWKz7BCs2002nVdouaqr/7nVTPjR5eZsXciDzSltPuin
	6TQKeTohiSeNtVPcWXqxg==
Message-ID: <6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
Date: Tue, 11 Mar 2008 19:36:36 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: boot cgroup questions
Cc: "Paul Jackson" <pj@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47D7411E.1000009@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D73086.2030008@qualcomm.com>
	 <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	 <47D7411E.1000009@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 7:34 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>
>  Suppose we were to do it from kernel. What's the right way to create a cgroup
>  without mounting a cgroupfs ?

There isn't really a way, but you could always kern_mount() a
filesystem inside the kernel.

>  I just want to play with it. There are a couple of advantages that I see for
>  doing it from kernel. We can move 'kthreadd' and idle threads into the 'boot'
>  cgroup early on and therefor later on won't even have to iterate through the
>  tasks and stuff.

Would this be done based on some boot commandline option? I don't
think you'd want to do it unconditionally.

Paul
