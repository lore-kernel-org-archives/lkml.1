Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbYCLTQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbYCLTQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYCLTQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:16:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3779 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYCLTQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:16:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Xe/Tg2CSWQj9kfpaTqCHR4uPqytlYtagUJE81FwdSCJKN4xFTSq1S5dp38bDu1hL/
	8HMdma6i76RqfPIoyWUbA==
Message-ID: <6599ad830803121216y32b88d15r462aac437142d814@mail.gmail.com>
Date: Wed, 12 Mar 2008 12:16:26 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: boot cgroup questions
Cc: maxk@qualcomm.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080311235939.1ebee8e3.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D73086.2030008@qualcomm.com>
	 <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	 <47D7411E.1000009@qualcomm.com>
	 <6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	 <47D74595.4080100@qualcomm.com>
	 <6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	 <20080311235939.1ebee8e3.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 9:59 PM, Paul Jackson <pj@sgi.com> wrote:
>
>  Paul M -- could we take a different tack here -- extend cgroups to map
>  -either- tasks or irqs to the managed resources?

Not cgroups, no. If you really wanted to extend cpusets specifically
to allow irqs to be assigned to a cpuset to control which cpus they
could execute on, then that might be a possibility. But I don't see
how this would be useful for any other cgroup subsystem, so it doesn't
belong in the generic framework.

My feeling is that just using a simple bitmask assignment, unrelated
to cpusets or cgroups, as Max suggested in his later email is the way
to go.

Paul
