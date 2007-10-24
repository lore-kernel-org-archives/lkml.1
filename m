Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbXJXDdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbXJXDdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXJXDdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:33:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:5866 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbXJXDdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=evMRpFNoVR+Ce/PaNoyC7K8E2dmgzKDvqOyHo5fxd85M0fyDjjyc91hrOdE+xYGm1RlEzfZBgSox1i2UBel9v0dK7gbFaMUw7IvEZTvVL1e6s2z0T7al0qC6VQxOMHux4XTmmNkKNUUXm+Ntvh+oANzTMoiRQy7rbRFxmAA+nkc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ryan Lortie <desrt@desrt.ca>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Date: Tue, 23 Oct 2007 23:33:08 -0400
User-Agent: KMail/1.9.7
Cc: "Zephaniah E. Hull" <warp@aehallh.com>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
References: <20070609084800.GR6362@aehallh.com> <d120d5000710231110u79ea11a8p38f1fc4654a7fac2@mail.gmail.com> <1193191094.32696.2.camel@moonpix.desrt.ca>
In-Reply-To: <1193191094.32696.2.camel@moonpix.desrt.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710232333.08306.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2007, Ryan Lortie wrote:
> On Tue, 2007-23-10 at 14:10 -0400, Dmitry Torokhov wrote:
> > No, rfkill want to see keypresses, period. It does not care if there
> > are other applications also seeing the same keypresses, it just does
> > not want keypresses stolen from it.
> 
> Right.  This is exactly the problem.  The current grab API exists to
> prevent keys from being delivered to normal users, but rfkill still
> wants to see them.
> 
> No matter how you slice it, if both of these desires are to be satisfied
> then there needs to be some sort of a system to differentiate between
> rfkill and "normal users".  That's what the priority is here.
> 

And the solution is pretty simple - do not use grab.

-- 
Dmitry
