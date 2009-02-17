Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZBQWOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZBQWOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZBQWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:14:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:38096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZBQWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:14:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jV0awO58tFKztDcT+v6oxzHTfxE1cpOZDQ7kC5vFvoYMsf/roLvaJgAvwm7B3UE2kS
         tPJkMEJGbZwgAQDZwbxh8zRVP4WNfA93k0e9vCIvIjdiXaAJt8YDPoa10HO6xcbvLx3r
         qRHvYELR8OdOznquDhRjw4DMiSQSdKxBNlEMg=
Date: Wed, 18 Feb 2009 01:20:32 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Junio C Hamano <gitster@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       =?utf-8?B?IlMuw4dhxJ9sYXIgT251ciI=?= <caglar@pardus.org.tr>
Subject: Re: [PATCH] Add *.rej to .gitignore
Message-ID: <20090217222032.GA7881@x200.localdomain>
References: <499B1729.5040802@goop.org> <alpine.LFD.2.00.0902171315400.21686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902171315400.21686@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 01:16:32PM -0800, Linus Torvalds wrote:
> On Tue, 17 Feb 2009, Jeremy Fitzhardinge wrote:
> > 
> > (This effectively reverts 1f5d3a6b6532e25a5cdf1f311956b2b03d343a48)
> 
> I really dont' think we should ignore .rej files. 
> 
> They are _error_ cases, after all. People want to know about them. And if 
> you don't want to see them, you should remove them.

Or you can see .gitignore as a list of files that shouldn't _ever_
be committed. This is objective definition instead of some
"we most certainly don't want to ignore them".

I added *.rej because of this, ignored revert, because was sick and
tired of possible arguing, and the inability of reverter to write
rej-ls script.
