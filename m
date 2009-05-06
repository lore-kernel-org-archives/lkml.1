Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbZEFNyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbZEFNyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZEFNyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:54:06 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:52017 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZEFNyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:54:05 -0400
Date: Wed, 6 May 2009 14:28:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Rik van Riel <riel@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       chrisw@redhat.com, alan@lxorguk.ukuu.org.uk, device@lanana.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses registrations.
In-Reply-To: <20090506131735.GW16078@random.random>
Message-ID: <Pine.LNX.4.64.0905061424480.19190@blonde.anvils>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com>
 <1241475935-21162-2-git-send-email-ieidus@redhat.com>
 <1241475935-21162-3-git-send-email-ieidus@redhat.com> <4A00DD4F.8010101@redhat.com>
 <4A015C69.7010600@redhat.com> <4A0181EA.3070600@redhat.com>
 <20090506131735.GW16078@random.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Andrea Arcangeli wrote:
> 
> For example for the swapping of KSM pages we've been thinking of using
> external rmap hooks to avoid the VM to know anything specific to KSM
> pages but to still allow their unmapping and swap.

There may prove to be various reasons why it wouldn't work out in practice;
but when thinking of swapping them, it is worth considering if those KSM
pages can just be assigned to a tmpfs file, then leave the swapping to that.

Hugh
