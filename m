Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbXJ2Ju0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbXJ2Ju0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXJ2JuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:50:17 -0400
Received: from grex.cyberspace.org ([216.86.77.194]:31504 "EHLO
	grex.cyberspace.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXJ2JuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:50:15 -0400
Date: Mon, 29 Oct 2007 05:50:15 -0400
From: Roopesh <roopesh@cyberspace.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Roopesh <roopesh@cyberspace.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MMC: CRC Errors with 2GB cards
Message-ID: <20071029095015.GA20714@grex.cyberspace.org>
References: <20071019161700.GA19254@grex.cyberspace.org> <20071027140017.41e9d67f@poseidon.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027140017.41e9d67f@poseidon.drzeus.cx>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Pierrie, 

 Thanks for writing back. 

:     > -			} while (!(cmd.resp[0] & R1_READY_FOR_DATA));
:     > -
:     > +			} while (!(R1_CURRENT_STATE(cmd.resp[0]) == 4)); 
:     > +			
:     >  #if 0
:     
:     This might trade us one problem for another. Could you try the following:
:     
:     } while (!(cmd.resp[0] & R1_READY_FOR_DATA) || (R1_CURRENT_STATE(cmd.resp[0]) == 7));
:
:     
:     This should also work for cards that mishandle the state field, and if the card jumps to
:     some odd state for some reason.
:     
:     > 
:     >  I am just wondering if I have set of broken cards.  Any pointers 
:     >  in this regard?
:     > 
:     
:     You do. But don't be too alarmed, that is unfortunately the norm. :/
:     

 I have purchased 4 Transcend cards, and all of them behave the 
 same way.  Just wondering why others dont have this problem, and 
 why such a fix hasn't made it to main tree yet.

 I have tried the fix, and it works fine.  Thanks.

 Roopesh.
