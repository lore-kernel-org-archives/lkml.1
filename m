Return-Path: <linux-kernel-owner+w=401wt.eu-S940838AbXHIPji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940838AbXHIPji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939643AbXHIPj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:39:28 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:35964 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S939631AbXHIPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:39:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BdsOVkPCM1+w6dqWlhJDyVTb4Pg04z1y2+ZBhJccm6bakL0NfM1OUEWpGhYf+bGy2R0xyDz6fl4hrl3+SovJnRXWFZft0N+YwXP8xFea5GCbUyLTExfETYOX0eShRJcR+cW6FdYSKp3vsWZ0M1XL5eQL5pY4fAHhhtpofGz7xyg=  ;
X-YMail-OSG: QEvO3W4VM1nlCSFG2GSVrDHfIx4tLu.tPSgwcUmsCNkkcg.sOl0kUX4Bxa3O7i9SFwbFZoz.fGAEmrNBWz5xuBFPHf2IcYpppEARgJ6ZyaRhHZog1ZL4ax8HMyfb.I0rsUEuS0n2aR13AQ--
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [2.6 patch] drivers/i2c/i2c-core.c: make code static
Date: Thu, 9 Aug 2007 08:39:27 -0700
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
References: <20070729145708.GL16817@stusta.de> <20070809110526.5c2c7d6c@hyperion.delvare>
In-Reply-To: <20070809110526.5c2c7d6c@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708090839.28257.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007, Jean Delvare wrote:
> > -EXPORT_SYMBOL_GPL(i2c_bus_type);
> 
> This one was left exported on request by David Brownell. See this
> discussion thread:
> http://lists.lm-sensors.org/pipermail/i2c/2007-March/000924.html

Actually, that wasn't a request; it was me answering why I didn't
put a particular comment there, as part of moving an existing export
declaration up next to the symbol's definition.


> I am personally fine with removing this export, as it can always be
> added later if needed. 

Right, that's what various other busses do.


