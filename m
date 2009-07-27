Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZG0SnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZG0SnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbZG0SnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:43:09 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:46859 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZG0SnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VsRxt++9OimSZATHZj1vomYsn6dmnlvKIQAXiVtK14W6jJELrq0SlU9EkwlXTTERsW
         cuKBWj0drnNUS3//CywEwj4xaBOBgKtU5jSUTW1FrRvjyo1EVR6sC4l6KqAldDyjUuNC
         PWldlqZkgt/YLoD3eu4+26DkCZib2dMhlljdM=
Date: Mon, 27 Jul 2009 20:43:02 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Doug Thompson <norsk5@yahoo.com>
Cc: dougthompson@xmission.com, borislav.petkov@amd.com,
       wan wei <onewayforever@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: fix insmod fail while ecc is enabled
Message-ID: <20090727184302.GC3044@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
	borislav.petkov@amd.com, wan wei <onewayforever@gmail.com>,
	linux-kernel@vger.kernel.org
References: <86bb1aef0907270947o6219f950xf13a077b30486d41@mail.gmail.com>
 <368206.16549.qm@web50108.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <368206.16549.qm@web50108.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 27, 2009 at 11:01:26AM -0700, Doug Thompson wrote:
> In a prior email you indicated that you refactored the function in
>question. What that in the series of patches you submitted? I think
>that set is too big to get in the RC branch.
>
> We need this in 2.6.31 in order for the module to even work.
>
> Shall we push my simple one, or your complete refactor?

I wanted to give my refactoring patch a little testing in linux-next but
my gut feeling tells me it would be wiser to go with your fix that late
in the cycle and postpone mine for the next kernel. In the meantime,
it'll see more testing in linux-next.

I'll push the two fixes tomorrow if Linus hasn't pulled yet otherwise
I'll have to wait for -rc6 with your patch, but even that'll do.

-- 
Regards/Gruss,
    Boris.
