Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZG2Sqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZG2Sqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 14:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZG2Sqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 14:46:32 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59565 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZG2Sqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 14:46:31 -0400
X-Greylist: delayed 2624 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 14:46:31 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=NbU/rLO9S5NJK1CvgihBbFevarp/k8vfsc7q+k2a/B7ZdM3hOpC8XQ/nFsQjy5xyWa
         zeXkHaVXrWLqOcQCirByrW5RByZ1nM/61ujn0P+wm/a25LlZ5Au5UCHIqDtegow13E0D
         s7YJxrBmhpcXrs6w3blBgXL+qUl3aD3QWBR5w=
Date: Wed, 29 Jul 2009 20:46:28 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: execute on the correct CPU subset
Message-ID: <20090729184628.GB28534@liondog.tnic>
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
 <20090729180244.GA28534@liondog.tnic>
 <4A708F75.3030907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A708F75.3030907@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 11:05:41AM -0700, H. Peter Anvin wrote:
> On 07/29/2009 11:02 AM, Borislav Petkov wrote:
> >  
> >> Furthermore, are there any users for this interface at this time?
> > 
> > Yep, drivers/edac/amd64_edac.c.
> > 
> 
> So let's see... you're asking to change an in-use interface late in the
> -rc series when it has active users?

Ok, I could create a minimal patch with only the bugfix and send
the remaining changes later during the next merge window, if that's
preferred?

-- 
Regards/Gruss,
    Boris.
