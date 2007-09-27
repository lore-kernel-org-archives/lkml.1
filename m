Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbXI1OLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbXI1OLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXI1OLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:11:43 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:48843 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750878AbXI1OLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:11:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Ezsmhm2AcGe4lOJpa3M4TgHQ728qnnLe5iBsjoxJDnp2+zK8cBVGwB/dDGyqMwTqDvqZmjQ2aW65RbFUn0XlR6ob/GU5VuBEQJ4Oi64uWCxBoH5/gWC+9UTwLzimmHSumLOw6Y0ibnMO/1vVj5u6WYUtLaSQWRNi5puANgB+NZg=  ;
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dag Nygren <dag@newtech.fi>
Subject: Re: 2.6.22.3 out of memory crash
Date: Fri, 28 Sep 2007 07:40:18 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070920065603.CB75310154@dag.newtech.fi>
In-Reply-To: <20070920065603.CB75310154@dag.newtech.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709280740.18641.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 16:56, Dag Nygren wrote:
> Hi,
>
> I have the kview zoom function mapped to the scrollwheel
> with ctrl.
> Now my wife found out and watching our photos wanted
> to zoom out a bit. Then she just rotated the scrollwheel a lot
> and expected the zoom to happen. What did happen was that
> as the there was no apparent response she tried again, and again.
>
> Finally the box probably was out of swap space (2GB RAM) and crashed
> miserably.
>
> This is not the expected behavior from a Linux box using a graphics
> viewer and I now wonder if there is something I can do about it?
> Kernel parameters?
> Kview patch?
> New wife ;-)
>
> Best
> Dag


If the app has used up all memory, then there is not a great deal
that the kernel can do about it.

The oom-killer ideally I suppose should terminate your kview process
and the machine should continue normally after a fashion. How did
it actually die? Any kernel messages?
