Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYJ2Pkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYJ2Pkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYJ2PkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:40:20 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45447 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752896AbYJ2PkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:40:19 -0400
Date: Wed, 29 Oct 2008 11:40:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nick Piggin <npiggin@suse.de>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: potential regression in ext[34] call to __page_symlink()?
Message-ID: <20081029154014.GA23643@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nick Piggin <npiggin@suse.de>, Mike Snitzer <snitzer@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kirill Korotaev <dev@openvz.org>
References: <170fa0d20810281711s2a508ed2o1af0db30733e8d2d@mail.gmail.com> <20081029024048.GB3766@mit.edu> <20081029032557.GA17624@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029032557.GA17624@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 04:25:57AM +0100, Nick Piggin wrote:
> 
> I was leaning towards adding a new AOP_FLAG_ there, usable just by
> filesystem code, and just to tell any helper code to clear __GFP_FS.
> That way callers won't get confused into thinking they can do
> GFP_ATOMIC writes from interrupt context or something ;) (which,
> trust me, somebody will attempt to do if it looks remotely feasible!)

Good point!!

						- Ted

