Return-Path: <linux-kernel-owner+w=401wt.eu-S1767162AbXCILLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767162AbXCILLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767172AbXCILLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:11:22 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:42354 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767162AbXCILLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:11:21 -0500
Date: Fri, 9 Mar 2007 13:11:20 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Niklaus <niklaus@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: more than 65535 outbound connections
Message-ID: <20070309111120.GE3883@mea-ext.zmailer.org>
References: <85e0e3140703090016h609ecc5t504121a99bcd3e44@mail.gmail.com> <82d53izucg.fsf@mid.bfk.de> <Pine.LNX.4.63.0703090027310.30949@qynat.qvtvafvgr.pbz> <85e0e3140703090243n36fd467dwc83aff0d7b6fb004@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85e0e3140703090243n36fd467dwc83aff0d7b6fb004@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 04:13:00PM +0530, Niklaus wrote:
> yes now lets take 2 dest machines , source ip is fixed , source port (2^16 
> - 1)
> destip is fixed (a.a.a.a and b.b.b.b) ,dest port(2^16 -1) each ,
> 
> for a connection we have one port used , say connection 1 is
> 
> source ip,port 1 , a.a.a.a port 1
> source ip,port 2 , a.a.a.a port 2
> .
> .
> .
> source ip,port 65535 , a.a.a.a port 65535

You do have some sort of fixation of having same port numbers at both ends.
In some rare applications that is done (e.g. with NTP server-server connections
using UDP), but it is very rare and never done with TCP.

Now if you have 65535 server ports at a.a.a.a, you can have very nearly
4000 million TCP streams in between them.

> so total of 65535 connections (assume traffic is still going on, a
> movie on a slow line dialup or 1kbps )
> 
> now if i try to open another connection (assume lots of file
> descriptors are present) to a.a.a.a what happens
> 
> to b.b.b.b what happens
> 
> i think both will not get established as the OS doesn't have any free
> source ports or am i wrong

  you are wrong.
 
> >David Lang

/Matti Aarnio
