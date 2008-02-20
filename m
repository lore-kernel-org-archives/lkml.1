Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbYBTIeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbYBTIeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYBTIeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:34:03 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:45912 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYBTIeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:34:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qSddp65t3kVAWY86eTjvGWPRy6U3TS55PzW7NK+viCM85gIzeeUelButjy/n5ddwnDE75LP8CrHIODfgDbW9XlrmcjxMA895S2rqbAFYnk64cslh6rZBPpGy6TJSh40E/qCj8B4MF7H1escQVXY4EK49fX2+C+aAifO1NCEEf7w=
Message-ID: <86802c440802200033h35bf670y111c75998434f019@mail.gmail.com>
Date: Wed, 20 Feb 2008 00:33:59 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 6/8] net: use numa_node in net_devcice->dev instead of parent
Cc: "David Miller" <davem@davemloft.net>, greg@kroah.com,
       akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080220062706.GB7493@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219112146.GC7204@elte.hu>
	 <20080219.034110.191579889.davem@davemloft.net>
	 <200802191142.48891.yinghai.lu@sun.com>
	 <20080219.145512.142721224.davem@davemloft.net>
	 <86802c440802191510m7afc200eg979ebd4a1cf4a41f@mail.gmail.com>
	 <20080220062706.GB7493@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 10:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> > > > can you check the 5/8? that will make sure every struct device get
> > > > numa_node get assigned.
> > >
> > > Why do we need to bother with that if the parent will have the
> > > necessary information for us here?
> >
> > less code?
> >
> > or some kind of usb or other bus interface. may have several level...
>
> you mean it's a small optimization: otherwise every struct device (net
> dev, usb...) need to go back to find another pci device (parent or host
> controller) to use their numa_node.
>
Yes.

YH
