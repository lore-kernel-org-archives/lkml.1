Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZHCDPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZHCDPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 23:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZHCDPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 23:15:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:61763 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZHCDPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 23:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eQGI+O61UgrLx3OIfnzENNYG5fe/IqEHNmbYxugVcchNM5OGr5vG/FOA6EmhRWZzhM
         Euat9VSETGUOdzN9IVLCS7XzuJXzWeixr6l4SH1wz14R/7IF9Yj6+VLvC8d54tT1DReU
         pRDciJRD0qEJHTmSFlPcNk2NaD0umj95RQQrY=
MIME-Version: 1.0
In-Reply-To: <20090728104434.GA1728@fluff.org.uk>
References: <20090728104434.GA1728@fluff.org.uk>
Date: Mon, 3 Aug 2009 12:15:13 +0900
Message-ID: <aec7e5c30908022015u4ec2489ex49bad474893c66f3@mail.gmail.com>
Subject: Re: Converting to dev_pm_ops (remove annoying warnings)
From: Magnus Damm <magnus.damm@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben!

On Tue, Jul 28, 2009 at 7:44 PM, Ben Dooks<ben-linux@fluff.org> wrote:
> I have a couple of questions about changing drivers to use the
> dev_pm_ops method within drivers using the device driver model.
>
> 1) Should the suspend/resume code still be wrapped in #ifdef CONFIG_PM
>   and supply a NULL 'struct dev_pm_ops' wen CONFIG_PM=n
>
> 2) Is it allowable to submit changes to move drivers to dev_pm_ops
>   during the -rc phase, or do we have to wait for the merge window
>   before sending these? The number of warnings on a system that
>   relies heavily on platform devices is annoying (S3C24XX ARM).

To begin with: I'm the one to blame for the annoying printouts. If
people dislike the printout then I'm all for disabling it later on in
the -rc phase. As you understand the goal is to motivate people to
update their drivers. =)

I'm not the right person to answer the merge policy question, but
wouldn't it be good to submit patches regardless of when they will be
picked up? OTOH, I guess knowing when helps if you have a bunch of
other changes queued up for your drivers though...

Any thoughts?

Cheers,

/ magnus
