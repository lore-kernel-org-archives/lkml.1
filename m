Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbYCKWyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbYCKWyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYCKWy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:54:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34172 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYCKWy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:54:27 -0400
Date: Tue, 11 Mar 2008 23:56:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, wli@holomorphy.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Terminate hugetlbfs mount argument list
Message-ID: <20080311225623.GE428@one.firstfloor.org>
References: <20080311224204.GA16719@basil.nowhere.org> <adabq5klvw1.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adabq5klvw1.fsf@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 03:48:46PM -0700, Roland Dreier wrote:
>  > The match_table_t for the mount arguments in hugetlbfs wasn't 
>  > terminated as match_tokens expect. I didn't see a crash just code
>  > audit, but it's still safer to terminate it in case the variables after
>  > that in .data are not NULL.
> 
> I think you're misunderstanding the match_token() interface.  The
> comment before match_token() says:

Hmm indeed I did. To my defense it's a weird unusual coding pattern
that tricked me.  What good is it to give terminator elements own enum values?

-Andi
