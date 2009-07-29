Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZG2SJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZG2SJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 14:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZG2SJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 14:09:51 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:35053 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZG2SJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 14:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=sJomHwAZ7i79vRMEnkUdyHHvJ0gHrWN/rIMW0zejkX/8nFuOxw3RppZ7RCO8D22wRd
         2m494js+QV47kFOoNACdTGPxUW5u/VfrERang7Gb6CRE3DtERDf8HHxOTkb2LK3VW/Pu
         F6XTBylV26hUL5YGc0bop//hnKfqNCph8DK34=
Date: Wed, 29 Jul 2009 20:02:44 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: execute on the correct CPU subset
Message-ID: <20090729180244.GA28534@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com>
 <4A526D38.7000803@zytor.com>
 <20090707103723.GD5668@aftab>
 <4A537010.3050905@zytor.com>
 <20090708111911.GC19315@aftab>
 <4A6E1222.5010709@zytor.com>
 <20090729164941.GA9388@aftab>
 <4A708745.5040203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A708745.5040203@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 10:30:45AM -0700, H. Peter Anvin wrote:
> On 07/29/2009 09:49 AM, Borislav Petkov wrote:
> > On Mon, Jul 27, 2009 at 01:46:26PM -0700, H. Peter Anvin wrote:
> >> Any reason not to use get_cpu() ... put_cpu() instead?
> > 
> > In case you haven't applied the one from yesterday yet, here's a better
> > one which uses struct cpumask * instead of cpumask_t.
> > 
> 
> Mangled patch (quoted-printable).

Sorry about that, will resend tomorrow.
 
> Furthermore, are there any users for this interface at this time?

Yep, drivers/edac/amd64_edac.c.

-- 
Regards/Gruss,
    Boris.
