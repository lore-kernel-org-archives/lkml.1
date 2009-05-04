Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZEDKNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZEDKNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZEDKNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:13:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41194 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZEDKNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:13:39 -0400
Date: Mon, 4 May 2009 12:18:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
       Elad Lahav <elahav@uwaterloo.ca>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Implementation of the sendgroup() system call
Message-ID: <20090504101814.GG23223@one.firstfloor.org>
References: <49FE47A1.7070700@uwaterloo.ca> <87eiv5ibnd.fsf@basil.nowhere.org> <49FE9999.7090103@redhat.com> <20090504095300.GF23223@one.firstfloor.org> <49FEBBC9.9000708@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49FEBBC9.9000708@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 11:56:25AM +0200, Eric Dumazet wrote:
> Andi Kleen a écrit :
> 
> >>> Or perhaps simple send to a local multicast group and let
> >>> some netfilter module turn that into regular UDP.
> >>>  
> >> Sounds hacky and rooty.
> > 
> > rooty? Everyone can send to all directions anyways.
> > 
> > It wouldn't be perfect, but quite usable as a short term solution
> > for a production server.
> 
> Anyway, a netfilter module doesnt fit the needs (separate header/footer
> for each destination)

netfilter modues can create new skbs that reference the main data and replace 
the header.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
