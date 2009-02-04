Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZBDG1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZBDG1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 01:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZBDG1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 01:27:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbZBDG1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 01:27:09 -0500
Date: Tue, 3 Feb 2009 22:26:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Eli Cohen <eli@mellanox.co.il>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
Message-Id: <20090203222601.747ca8b7.akpm@linux-foundation.org>
In-Reply-To: <aday6wmn2vr.fsf@cisco.com>
References: <20090203164930.GA10101@mtls03>
	<ada8wonnh3t.fsf@cisco.com>
	<1233712248.16867.131.camel@pasglop>
	<20090203211329.d6190a08.akpm@linux-foundation.org>
	<aday6wmn2vr.fsf@cisco.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Feb 2009 22:16:08 -0800 Roland Dreier <rdreier@cisco.com> wrote:

>  > I think it's something like
>  > 
>  > 	huge_page_size(page_hstate(page))
> 
> That would suit.  I assume the intention is for that to be usable by
> driver modules on any architecture?
> 

erm, you overestimate the amount of planning and forethought which goes
into these things ;)

The lack of any EXPORT_SYMBOL(size_to_hstate) is a broadish hint.

