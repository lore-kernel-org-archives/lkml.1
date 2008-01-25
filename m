Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbYAYERT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbYAYERT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 23:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYAYERK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 23:17:10 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:24118 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751379AbYAYERK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 23:17:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=E4QgSk20mazRtFykGrreiavH95WVhW21XVLZxMszYCv38GQDEIE2mh994PId3iV7yKoAv0OnThwyk8QAS8oa9DelWxBlmkCWnAX7Y0GQmxhk1CTlLLVPRTgxtDVW+kUWKD2omzVlSh+nTfDL+vYlR2s/vh/Dm0eK9/ACdjESKJM=  ;
X-YMail-OSG: TqCmYnQVM1nLpF9NlE.UXknB0NRa9DLuc7Xt.IwwR8Y33G5AHhgi3tRcv7d9dW07mKFtnDyA0g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC] some page can't be migrated
Date: Fri, 25 Jan 2008 15:17:02 +1100
User-Agent: KMail/1.9.5
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com> <1201233590.28282.13.camel@sli10-desk.sh.intel.com> <Pine.LNX.4.64.0801242000320.1932@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0801242000320.1932@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251517.02287.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 15:01, Christoph Lameter wrote:
> Acked-by: Christoph Lameter <clameter@sgi.com>
>
> Nick? Ok with you too?

Yeah, for memory hot remove that makes sense. A comment
might be in order, at least a reference to the orphaned
page code in vmscan.c.

Otherwise, it is OK by me.

Acked-by: Nick Piggin <npiggin@suse.de>
