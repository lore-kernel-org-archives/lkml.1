Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYJ3WL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYJ3WL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYJ3WLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:11:21 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:27962 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751929AbYJ3WLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:11:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=murjOK9iMgMrZCK2l/hTE3NSkptnW/WFmM9O5BY3YAVsBoweXhz87rFNIgtoBoNdxDJDaxPFLslIp4WJKs+7l9ga11HHDpkK9CoBubK5l9eeMiTvE56aQa/UPDA7n4fsmqhGULDgVZ9hWF2HYI16QUCu509x7eVE+WKYuL3EReI=  ;
X-YMail-OSG: yLqroKEVM1nqOvmHjrYyUwBnLEM21qM363vappz29Mfe_jahlRE8tihwFJpa3Lp9qiL8pEzdJS6oQEbk5l58tdYsYSHRAXYVcP2V3Ae4hbuiLkc17tuPSB0X1LNvGwd0HSFZlh86pAjIskUK2FK2jLUvMTU.kwB8AwkjGYw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nate Case <ncase@xes-inc.com>
Subject: Re: [PATCH] rtc-ds1307: Reset bogus register values on m41t00
Date: Thu, 30 Oct 2008 15:11:18 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1225301377-9092-1-git-send-email-ncase@xes-inc.com> <1225398691.27415.170.camel@localhost.localdomain> <1225402486.27415.177.camel@localhost.localdomain>
In-Reply-To: <1225402486.27415.177.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810301511.18307.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2008, Nate Case wrote:
> On Thu, 2008-10-30 at 15:31 -0500, Nate Case wrote:
> > I'll go ahead and re-spin the patch.
> 
> After thinking about this more, I'm not sure it's right to do anything
> more than the "remove legacy probe checks" patch already does.  Can you
> think of any harm in having the oscillator running with bogus register
> values? 

Not really.  If you're content with that patch, I won't worry
any more.


> Calls to get_time() will return -EINVAL, but that seems to be 
> the norm for any "bad time" condition.  It makes me think that resetting
> to a sane time is putting more policy than desired in the driver.

That's a very defensible position.  It does mean you'll want
your userspace to defend against that, but that's not hard.

- Dave
