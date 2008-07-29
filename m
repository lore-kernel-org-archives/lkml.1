Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbYG2Onv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbYG2Onv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbYG2Onn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:43:43 -0400
Received: from gw.goop.org ([64.81.55.164]:53064 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbYG2Onn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:43:43 -0400
Message-ID: <488F2C9B.9070306@goop.org>
Date: Tue, 29 Jul 2008 07:43:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, steiner@sgi.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Comments on UV tlb flushing
References: <488E644B.10801@goop.org> <200807291412.18495.nickpiggin@yahoo.com.au> <20080729133204.GA13138@sgi.com>
In-Reply-To: <20080729133204.GA13138@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
> I think that the Linux distributions are not going to build a special
> UV kernel, are they?  So every distro would have to be prompted to 
> turn on CONFIG_X86_UV, or else their kernel is not going to boot on UV.
>   

Distros will generally turn on everything.  You could have it on by 
default if the kernel is built for CONFIG_X86_GENERICARCH which enables 
support for other big numa configurations.  I think distros generally 
build with that enabled anyway.

    J
