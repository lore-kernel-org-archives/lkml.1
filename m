Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZKRDDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZKRDDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbZKRDDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:03:52 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:34197 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbZKRDDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wz0yLcwazJzvoSKdVO94NenmwAgy6FOOTaZaPl9wcHTRIE4HhLFlq/OkxJHRkKde16
         yM/oBlUkBUUnj1KA82AaplMPvlIRdcoYI2zdaR1+DnYlnkFDq/gXg9RRv9Jn9RrRKXYf
         O3Ah4EhsKcaYXCe73jryHfxNRMxXoGhp5tNvQ=
MIME-Version: 1.0
In-Reply-To: <E1NAYJo-00016g-PW@pih-relay04.plus.net>
References: <E1NAYJo-00016g-PW@pih-relay04.plus.net>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 18 Nov 2009 11:03:38 +0800
Message-ID: <f17812d70911171903v230b1598mc8e5ff2a4b5195b8@mail.gmail.com>
Subject: Re: [PATCH] hx4700: fix hx4700 touchscreen pressure values
To: Paul Parsons <lost.distance@yahoo.com>
Cc: pavel@ucw.cz, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       linux-kernel@vger.kernel.org, Dirk@opfer-online.de, arminlitzel@web.de,
       metan@ucw.cz, thommycheck@gmail.com,
       linux-arm-kernel@lists.infradead.org, dbaryshkov@gmail.com,
       omegamoon@gmail.com, utx@penguin.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 8:22 AM, Paul Parsons <lost.distance@yahoo.com> wrote:
>> Does pressure actually work as expected -- that is not inverted?
>> Because I need this patch on spitz...  but it may break your
>> machine...
>
> You are right, the pressure values were being inverted on my hx4700.
> Pressing hard generates somewhat lower Rt values than pressing lightly.
>
> Since typical hx4700 Rt values are close to (pressure_max/2) anyway,
> the inverted and non-inverted values were not very different.
> For example:
>
> Rt      ts->pressure_max-Rt
> 599     425
> 562     462
> 588     436
> 570     454
>
> So by all means submit your ads7846.c patch; it will not break hx4700.
>

Is this generically true that the pressure is always inverted? Otherwise
a platform specific field indicating this would be the better way to go.

- eric
