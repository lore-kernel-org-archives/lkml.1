Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbZDGTg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbZDGTg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZDGTgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:36:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbZDGTgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:36:20 -0400
Date: Tue, 7 Apr 2009 21:38:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robin Holt <holt@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Russ Anderson <rja@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [0/16] POISON: Intro
Message-ID: <20090407193834.GV17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407191300.GA10768@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407191300.GA10768@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 02:13:00PM -0500, Robin Holt wrote:
> How does this overlap with the bad page quarantine that ia64 uses
> following an MCA?

It's much more comprehensive than what ia64 has, mostly due to 
differing requirements. It also doesn't limit itself to user
mapped anonymous pages only.

-Andi
