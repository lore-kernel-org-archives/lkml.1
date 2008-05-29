Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYE2Vs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYE2Vs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbYE2Vsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:48:46 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:29136 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751843AbYE2Vsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:48:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tLZczGNw9axoB+nRXpB++AjJAbd26vQcxYY211ARbUja03wPRlC/PvU1SjuKFnYIme4bqQcPvUymSI7JERXWeZvFgTBzTPuCM0w+fgSrLP4zO8rcscf91ur/sWFPBpmymJHU3m0gzMFsFRo3YpVQZNq5j7Z3M3jaXeuXfJGpLco=  ;
X-YMail-OSG: T4Q3nR4VM1lP2WBWjBbtn96pKhsaB4tcyegtL5xZXfkN6YEH3cW27_YU9Fx2Hv8JvpG5bPtQ8fcqN1xQVMVJ8MzNyYdbww4GegM9oPzA1A--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
Date: Thu, 29 May 2008 14:48:39 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <20080529212110.GA2870@suse.de>
In-Reply-To: <20080529212110.GA2870@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291448.40075.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2008, Greg KH wrote:
>       USB: EHCI: fix performance regression

That's not a regresssion at all!  Plus, this patch shouldn't
have included the timeout change.  The timeout change is why
I didn't ACK this patch...

