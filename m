Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYJUFz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYJUFz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYJUFzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:55:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54047 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYJUFzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:55:11 -0400
Message-ID: <48FD6EDC.5010801@redhat.com>
Date: Tue, 21 Oct 2008 01:55:40 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Jeff Hansen <x@jeffhansen.com>
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
References: <1224552902.2640.88.camel@alok-dev1>
In-Reply-To: <1224552902.2640.88.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> This patch set makes some changes to the TSC code, so that it is always
> used as the default clocksource when running under VMware.
> The first 2 patches do the ground work of adding code to detect if we
> are running under VMware.
> The third patch adds a tsc_reliable flag which tells us that TSC is
> reliable on this system, so that we can skip some tests which can
> potentially mark TSC as unstable. Details under individual patch
> headers. 

Do you intend for this to supplement Jeff Hansen's tsc=stable patch, or to 
replace it?  If you intend to supplement it, you should rework your submission 
to make sure that both your autodetection and his command-line option use the 
same internal mechanism, and if you intend to replace it, you should say this 
explicitly, and justify it.  Either way, you should definitely CC Jeff on the 
submission, as I am doing now.

-- Chris
