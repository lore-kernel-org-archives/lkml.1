Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZHEEzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZHEEzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 00:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbZHEEzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 00:55:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:16451 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZHEEzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 00:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=qsc3G1KFVVGHK+VTzNvAbc3HDaO+nP7HUWy9UU9wObeOBXcvmGgXbciM9chA04vB7+
         ofOfxh43u0Ko3g/ll2xg8MpqbUf01cZwBz44UNlJ8+Fch5gX0IDZhAaemyH8jQ60ErdX
         73q2vuFjCbqAN4laeX8NPsjqGXrkLxBISdHPE=
Date: Tue, 4 Aug 2009 21:55:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Add SIMPLE_PM_OPS: make switching to dev_pm_ops less
	error-prone
References: <20090803163304.GF5002@laptop> <200908032123.17069.rjw@sisk.pl> <20090804093542.GA5854@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804093542.GA5854@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090805045533.C3574526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 11:36:12AM +0200, Albin Tonnerre wrote:
> In a number of cases, the .suspend, .freeze, .poweroff and .resume,
> .thaw, .restore functions are identical. However, they all need to be
> assigned to avoid regressionsm as the previous code called .suspend
> resp. .resume in all those cases. SIMPLE_PM_OPS allows to deal with
> this case.
> 

I'd much rather have conversions done with a bit more analysis now that
our framework is more flexible and we can have specialized routines for
hibernation and suspend.

Maybe we should try changing from run-time to build time warning so that
users are not overly concerned with it?

Thanks.

-- 
Dmitry
