Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYENOE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYENOE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYENOEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:04:48 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:39886 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751924AbYENOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:04:47 -0400
Date: Wed, 14 May 2008 10:03:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Glauber Costa <gcosta@redhat.com>, Glauber Costa <glommer@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix app crashes after SMP resume
Message-ID: <20080514140300.GB11520@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Hugh Dickins <hugh@veritas.com>, Glauber Costa <gcosta@redhat.com>,
	Glauber Costa <glommer@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh,

Many, many thanks!!  This fixed the my suspend/resume problem on my
X61s as well (where the X server would stop accepting keyboard and
mouse input, and subsequent to restart the X server after remote login
would fail).

      	   	     	  	       		      - Ted

