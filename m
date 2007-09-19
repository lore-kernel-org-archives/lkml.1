Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbXISVjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbXISVjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXISVjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:39:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:57391 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbXISVjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YktOV8gRUCVnmK7t8NEgJdIfRh0QXFoyuG2xtFXKPIS8XDjMoFskldikadQBF1LBYN8nRuaJ52WVTbsh8vEVHmomVkcKWOElwoe/Dw91mSTWs6eDLm7bgThAJcVtgcGszAhZJR15TF/REfWMji8+aQvrm7qcP1QmDhqOd/TfQtE=
Message-ID: <cb0375e10709191439v7e0aec69m1dd2db7ca5b12b8a@mail.gmail.com>
Date: Wed, 19 Sep 2007 17:39:46 -0400
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: A little coding style nugget of joy
Cc: linux-kernel@vger.kernel.org, kernel1@cyberdogtech.com
In-Reply-To: <20070919213010.GG18707@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070919123401.9369534d.kernel1@cyberdogtech.com>
	 <p73odfyvar1.fsf@bingen.suse.de> <46F19326.1040503@myrealbox.com>
	 <20070919213010.GG18707@one.firstfloor.org>
X-Google-Sender-Auth: 8cdea4cd5ba414bf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Andi Kleen <andi@firstfloor.org> wrote:
> > This is a terrible assumption in general (i.e. if filesize % blocksize
> > is close to uniformly distributed).  If you remove one byte and the data
> > is stored with blocksize B, then you either save zero bytes with
> > probability 1-1/B or you save B bytes with probability 1/B.  The
> > expected number of bytes saved is B*1/B=1.  Since expectation is linear,
> > if you remove x bytes, the expected number of bytes saved is x (even if
> > there is more than one byte removed per file).
>
> You didn't calculate the probability of actually saving a full block
> or not (that's the only thing that matters). I assumed it's relatively
> small and can be ignored in practice since the amount of end white
> space is negligible compared to total file size.

Sure I did.  It's roughly 1/B per byte removed ( = 1/4096 ).

--Andy
