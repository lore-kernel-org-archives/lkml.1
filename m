Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbXJ3VM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbXJ3VM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbXJ3VMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:12:49 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:34857 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752681AbXJ3VMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:12:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=B0cdIf8nHKwGW9KmOhtJu+Du6hr/Uxnha382zWyYf3OoXi0Z9mZFHkirOmt5R/YJaEUQ2YxqCadeIE7doAqmA5mMBVPKzTbKHGziOFLN6rD/xd4nkrDQyTAvioyN8NBMCH/dCVxbTlfEQlq71MbiwRZZQa+z3DyO8GNI9aNXwPs=  ;
X-YMail-OSG: Y.j3hskVM1lQp1KsVpJIchcNL85fi1ZQeFfIXeEtV4YbqnHbbrWlMdtHgZEUz.zU7pZ8ZG4Axg--
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 00/14] Blackfin on-chip SPI controller driver updates and bug-fixing
Date: Tue, 30 Oct 2007 13:54:19 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, Bryan Wu <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com> <8bd0f97a0710301329i8a21b22ncc9f71a81bc06543@mail.gmail.com> <200710301342.18559.david-b@pacbell.net>
In-Reply-To: <200710301342.18559.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710301354.19440.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007, David Brownell wrote:
> > 
> > was there something that caught your eye other than the ugly udelay()
> > you mentioned in the other thread ?
> 
> That one was a feature that might be more generally necessary,
> just to meet chip timing specs.  Mostly they're no trouble.
> 

... although I note that the referenced thread suggested maybe
the problem there was a missing pullup on the chipselect line.  If
that was really the cause, then I think that feature would best
be left out of the framework.  :)


