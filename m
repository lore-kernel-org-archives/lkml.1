Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYDHOwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYDHOwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYDHOw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:52:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbYDHOw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:52:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=AFocrYnZPxJ5+h++7C/3i5b87DfRLUE02a8jTyIs6mMxkRJf18zyZ9k9xlVG+a6HJ
	oHBeOAt3hng97AwekrSUQ==
Message-ID: <6599ad830804080752w15882801oaa4fb4b661e7302a@mail.gmail.com>
Date: Tue, 8 Apr 2008 07:52:16 -0700
From: "Paul Menage" <menage@google.com>
To: "Balaji Rao" <balajirrao@gmail.com>
Subject: Re: [RFC][-mm] [0/2] Basic stats for cgroups V2
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com, a.p.zijlstra@chello.nl,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200804081919.14601.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804052339.42474.balajirrao@gmail.com>
	 <6599ad830804080036h5496e3bdv9ac2dedf0f04f9bc@mail.gmail.com>
	 <200804081919.14601.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 6:49 AM, Balaji Rao <balajirrao@gmail.com> wrote:
>
>  We are also looking at a generic framework in cgroups that would delegate the
>  job of handling statistics to the cgroup framework itself. This would avoid
>  code duplication across various controllers.

Yes, avoiding code duplication is good.

On thing - when you say "statistics" do you mean all statistics (i.e.
all values that can be read from control files) or specifically
arrays/maps of values in specific control files? I'm using it to mean
the former, but you appear to be mostly referring to stats maps such
as "memory.stat" or "cpu.stat".

Paul
