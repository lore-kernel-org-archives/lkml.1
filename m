Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYDGN4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYDGN4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbYDGN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:56:12 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:36694 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYDGN4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:56:11 -0400
Subject: Re: [patch 01/10] emm: mm_lock: Lock a process against reclaim
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       kvm-devel@lists.sourceforge.net, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080405004127.GG14784@duo.random>
References: <20080404223048.374852899@sgi.com>
	 <20080404223131.271668133@sgi.com> <47F6B5EA.6060106@goop.org>
	 <20080405004127.GG14784@duo.random>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 15:55:48 +0200
Message-Id: <1207576548.15579.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-05 at 02:41 +0200, Andrea Arcangeli wrote:
> On Fri, Apr 04, 2008 at 04:12:42PM -0700, Jeremy Fitzhardinge wrote:
> > I think you can break this if() down a bit:
> >
> > 			if (!(vma->vm_file && vma->vm_file->f_mapping))
> > 				continue;
> 
> It makes no difference at runtime, coding style preferences are quite
> subjective.

I'll have to concurr with Jeremy here, please break that monstrous if
stmt down. It might not matter to the compiler, but it sure as hell
helps for anyone trying to understand/maintain the thing.


