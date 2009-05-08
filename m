Return-Path: <linux-kernel-owner+w=401wt.eu-S932298AbZEHTFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbZEHTFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764043AbZEHTFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:05:35 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:60297 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbZEHTFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:05:34 -0400
Message-ID: <4A048279.8020007@codemonkey.ws>
Date: Fri, 08 May 2009 14:05:29 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <4A019717.7070806@codemonkey.ws> <4A01B4CF.3080706@novell.com> <4A03EA83.6040907@redhat.com> <4A044DB5.7050304@novell.com> <4A046519.30604@redhat.com> <4A04802B.9000003@novell.com>
In-Reply-To: <4A04802B.9000003@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Its more of an issue of execution latency (which translates to IO
> latency, since "execution" is usually for the specific goal of doing
> some IO).  In fact, per my own design claims, I try to avoid exits like
> the plague and generally succeed at making very few of them. ;)
>
> So its not really the .4% reduction of cpu use that allures me.  Its the
> 16% reduction in latency.  Time/discussion will tell if its worth the
> trouble to use HC or just try to shave more off of PIO.  If we went that
> route, I am concerned about falling back to MMIO, but Anthony seems to
> think this is not a real issue.
>   

It's only a 16% reduction in latency if your workload is entirely 
dependent on the latency of a hypercall.  What is that workload?  I 
don't think it exists.

For a network driver, I have a hard time believing that anyone cares 
that much about 210ns of latency.  We're getting close to the cost of a 
few dozen instructions here.

Regards,

Anthony Liguori
