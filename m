Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYBHVqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYBHVqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbYBHVpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:45:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193AbYBHVpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:45:43 -0500
Message-ID: <47ACCD69.5010605@redhat.com>
Date: Fri, 08 Feb 2008 16:45:13 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
Subject: Re: [patch 43/45] x86: replace LOCK_PREFIX in futex.h
References: <20080207204118.202098927@mini.kroah.org> <20080207204821.GR16389@suse.de> <200802081935.34666.s.L-H@gmx.de>
In-Reply-To: <200802081935.34666.s.L-H@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2008 01:35 PM, Stefan Lippers-Hollmann wrote:
> 
> This patch seems to break compilation on x86_64 (i386 builds fine).
> 
>> -"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n\
>> +"2:	"lock cmpxchgl %3, %2\n\

Extra quote, should be:

+"2:	lock cmpxchgl %3, %2\n\
