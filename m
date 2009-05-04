Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbZEDHC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbZEDHC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZEDHCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:02:46 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:47250 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752590AbZEDHCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:02:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tgRdcvLssngiYy5MCleSY5/s/u5p2sGc+eCtny5q/LpeIvRwjAA1dnxW7k7YOVeXVGoOBXMpzncZSxPf1yxigWG+Ly1Lkrxef53PyZ68RkHwPksissr+s4ktEc2fs02qfm+S/EHYOglT4JC2u9ZGNZxu2Xdk8h7LpKw/J7iHymw=  ;
X-YMail-OSG: 4WVaY4AVM1kfUaZ4ST1wPKWo4ogW2xzSQwoolb2BawSSguhXCy0sZ0Q4Z26RHTTwmHlL9mBcBh_E.uGu73Br7eEjv5tKi8O3wP5anBawHi89_Dj.9OXj4US48I5ZlXC5gmfwfKpK_xi2oGhZvmGqd33ZShg5yQ47f5eu5MkFDWbT4v9CeDQsNho019zIskhOeESvbr0fDgQs_Px0xIzuizjwl3y5bb.jyY3tV6yRpdoUjS5DOTIDIOPnMJoXf.tZNBfnTVMZoYaEK6URiyIsdOkOIxFifi6BQ.XMyxAjyJiMY77ynSE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] usb: use memdup_user()
Date: Mon, 4 May 2009 00:02:38 -0700
User-Agent: KMail/1.9.10
Cc: Li Hong <lihong.hi@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com> <3a3680030905032038h40cd75bdrbee839117e5a4d55@mail.gmail.com> <200905040854.03329.oliver@neukum.org>
In-Reply-To: <200905040854.03329.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905040002.38304.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 May 2009, Oliver Neukum wrote:
> No. To make it plain. To me any use of memdup_user() in USB code
> is a bad idea. I don't want to have to think about a new primitive.

Unless it's incorrect to use that, I have to say that it
makes more sense to use that utility than recreate it by
open-coding...



