Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYLaIPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYLaIPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYLaIPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:15:06 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:4808 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYLaIPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i1g4v3QaIRYtJlsyTAYgFDNyqjT7rz/h8crTu/yh+iVEtDO8P+zezklR2MPDGlnWQo
         DRwJrCcRtPD2DrOaIsUj810WRr/mKqZSlCTfDzXOMpq3p/MZQZ5FsOYJ/iq06yseGTRy
         b16bwbhjkZ9/teXVXNpw+Yo7Ad7KzjWLGiJtM=
Message-ID: <495B2A02.5010701@gmail.com>
Date: Wed, 31 Dec 2008 00:14:58 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: tux3@tux3.org, sniper <s3c24xx@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
References: <200812301935.49303.phillips@phunq.net> <9bd6b5360812302334t2c6aca67s62ba54438d2bda9e@mail.gmail.com> <200812310000.55256.phillips@phunq.net>
In-Reply-To: <200812310000.55256.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Tuesday 30 December 2008 23:34, sniper wrote:
>   
>> Great, I have mounted tux3 filesystem under UML with stuffs in this mail,
>> but I still can't debug it with gdb. Anyone gives me suggestion?
>>     
>
> You just have to give a "cont" command a bunch of times and you will
> eventually get to a command prompt.  The reason for this is, uml uses
> the segfault interrupt as part of its machine simulation, and there
> is no exsiting way for uml and gdb to communicate in such a way that
> uml can recognize that the interrupt came from its own code and filter
> it.
>
> Jeff Dike is the expert on this, and Daniel Jacobowitz is the expert
> on the gdb side.  Fixing this would be a big effort, getting two complex
> systems to cooperate better, with nontrivial API issues to solve.  But
> UML is such a wonderful kernel development tool that it might be worth
> the effort.
>
> In the mean time, you could just tell gdb to mask off all segfaults,
> but would be kind of problematic for debugging.
>
> Regards,
>
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
Hmm.. seems like a redundancy;
Anyways I looked at you're site, but am still
confused at what tux3 is: what is tux3?
(at first I thought it was  a  video game, but was wrong);
can I use tux3 to secure a linux system or is it for
something else?

regards;

Justin P. Mattock
 
