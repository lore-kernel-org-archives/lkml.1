Return-Path: <linux-kernel-owner+w=401wt.eu-S1763082AbYGBJVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763082AbYGBJVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYGBJVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:21:06 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:25801 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752910AbYGBJVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:21:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GPVWhtDK0GhJo9WQGcQ4helxawVPDdjpdMH7fAZ8pFHOgXBOvRfBQh9jsrgulMqT9bolhfEn1bpEoCUOFAca2DGEQpCUHJFSNJ/uFEyXcxiIMT4zB6AzHRtCFqoi+N9AXl6MTvigl3/TM/fC7GYRzdI12tTpARXZRQjKp70TE3w=  ;
X-YMail-OSG: iOLMU4UVM1krK30mNv3Rr.0qR6328fMga2rjsxl378_mPm9xzL5c19WYEv1530NpQRHC6hdUpb5t4uKmRO660qXELN86MNPkvO934615K1S9eTs7Zvjl9g97Lz9jcbJXXV0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.26-rc8] drivers/power:  fix platform driver hotplug/coldplug
Date: Wed, 2 Jul 2008 02:21:02 -0700
User-Agent: KMail/1.9.9
Cc: kay.sievers@vrfy.org, mreimer@vpop.net,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       lkml <linux-kernel@vger.kernel.org>
References: <200807020013.14579.david-b@pacbell.net> <20080702014906.6303fd97.akpm@linux-foundation.org>
In-Reply-To: <20080702014906.6303fd97.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020221.02571.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008, Andrew Morton wrote:
> Do we think this is needed in 2.6.26?
> 
> In 2.6.25.x?

I don't think either.  Arguably this particular type
of driver should always be statically linked.  And
these are new enough that they weren't hit by the
regression (fix) aspect of $PATCH.

- Dave

