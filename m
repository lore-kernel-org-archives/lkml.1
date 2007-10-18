Return-Path: <linux-kernel-owner+w=401wt.eu-S1763718AbXJRUQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763718AbXJRUQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758677AbXJRUQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:16:01 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:6874 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbXJRUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:16:00 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: 2.6.23-mm1 s390 driver problem
Date: Thu, 18 Oct 2007 22:15:56 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       cornelia.huck@de.ibm.com, heiko.carstens@de.ibm.com, sam@ravnborg.org,
       schwidefsky@de.ibm.com
References: <20071018200148.GA14234@vino.hallyn.com>
In-Reply-To: <20071018200148.GA14234@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710182215.56428.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 18. Oktober 2007 schrieb Serge E. Hallyn:
> Sigh, well this turned out less informative than I'd liked.
> After bisecting 2.6.23 to 2.6.23-mm1, I found that
> git-s390.patch is the one breaking my s390 boot :(
> (Frown bc it's a conglomeration of patches0
> 
> Symptom is:
> 	"Cannot open root device "dasdd2" or unknown-block(94,14)"
> even though dasdd2 appeared to be found earlier in the boot.  I also
> get

Can you post the full console output from IPL to the unsuccessful end?

Thanks

Christian
