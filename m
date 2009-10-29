Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZJ2TKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZJ2TKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZJ2TKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:10:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbZJ2TKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:10:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ueLB9TSARf7TrRMMlBFMp8sj/vpuguPuZ+RCf5i6WuZdy5UvTOAnUwbjnc1Y9rtuq
	GJ/UhLTsd+nCpeWX9PGvw==
Date: Thu, 29 Oct 2009 12:10:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Juan Miscaro <jmiscaro@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How to immunize a process from the OOM Killer
In-Reply-To: <d0626390910291201m6e8121abq831867715f5d7d5@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0910291206480.27732@chino.kir.corp.google.com>
References: <d0626390910291201m6e8121abq831867715f5d7d5@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Juan Miscaro wrote:

> Hi, I'm running 2.6.24 on Ubuntu.
> 
> I've got a OOM Killer gone wild.  I have plenty of free memory (over
> 40 GB) and lots of processes are being murdered.  Anyway, I would like
> to first prevent a few processes from being killed in the hopes of
> buying me time (users can work) to discover why the killer is being
> invoked in the first place.
> 
> I've read in a few places [1] that in order to immunize a process you
> need to modify the value of /proc/PID/oom_adj.  Thing is, such files
> cannot be edited directly.  How do I achieve my goal?
> 

You need to do it as the superuser:

	$ sudo su
	# echo -17 > /proc/pid/oom_adj

or

	sudo sh -c "echo -17 > /proc/pid/oom_adj"
