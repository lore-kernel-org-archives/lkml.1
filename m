Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYK3C5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYK3C5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 21:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYK3C4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 21:56:55 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:22447 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754038AbYK3C4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 21:56:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O1IZoijgl4jjPLMvlFFZa7hsmrWZ0Qj/e7Gte6WJkmHLLQ553WitHv4Sc6FSl34wKU2iyxuJM1xbhdGQQay4vuTCIV3dKxsxZRXtwIG2Y57kZ2c4nddEKJCplAzfg1biGGNdEZn2aFYbZBfhlBmlrdh2FfBQAMpHTI7zYZpqYX0=  ;
X-YMail-OSG: 9xZsu8oVM1lXzjug0HMy0aJ5OZj4n0rbQ2nHriR8NQKrQtds5UCm89aM4W2QfbbyFguF6.DEqCjEeS52rSNJ5F3q2edUCXtvaBCKUcv02lsDdZVWEW.kJatplvEuYdqiJfPT_nqKXPwVgUIJjC5MUiG4YGc00vLiUfSKgGY-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] v4l2_device/v4l2_subdev: final (?) version
Date: Sat, 29 Nov 2008 18:56:51 -0800
User-Agent: KMail/1.9.10
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org,
       Laurent Pinchart <laurent.pinchart@skynet.be>
References: <200811291852.41794.hverkuil@xs4all.nl> <200811291422.20155.david-b@pacbell.net> <200811300006.22080.hverkuil@xs4all.nl>
In-Reply-To: <200811300006.22080.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811291856.51900.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2008, Hans Verkuil wrote:
> > > Are there some documented guidelines on when to use BUG_ON?
> >
> > Maybe there should be.  I know I've seen flames from Linus on
> > the topic.  Basically, treat it like a panic() where the system
> > must stop operation lest it catch fire or scribble all over the
> > (not-backed-up) disk ... if the system can keep running sanely,
> > then BUG() and friends are inappropriate.
> 
> I think it would be good to have some document about this, since
> from what I've seen from a quick scan I'm not the only one who uses
> it incorrectly. There is no documentation in the asm-generic/bug.h
> header and there is also no documentation on this in the Documentation
> directory.

Fair enough ... but the basic advice is still going to be "strongly
avoid ever calling BUG()".  

I'll send a patch along doing that.

- Dave


