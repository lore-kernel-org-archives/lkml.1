Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYJHT3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYJHT3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYJHT2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:28:52 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:20098 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbYJHT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YBB8NBfjl5W+IkP4jBg28hrArg2WeBYWUm+FmXEdYqPz1xHfkaqNNQs+PYpxua+MuR
         gmaew8hjdWJ8kXT0bli72mdnY6j/jy4/dK795jvCwpYOVQp2cFHSdhSSkAZ9IvXEhlkF
         j3Uq6DGErYcRLFvzcvwOmGx264/1ktuVkDeJk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [patch][repost] ide-tape build fix
Date: Wed, 8 Oct 2008 20:37:04 +0200
User-Agent: KMail/1.9.10
Cc: "Mark de Wever" <koraq@xs4all.nl>,
       "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Gadi Oxman" <gadio@netvision.net.il>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <48D79ABD.8060805@ru.mvista.com> <20081008154552.GA3907@localhost> <9ea470500810080922x326821c5p47053afa7a1d261e@mail.gmail.com>
In-Reply-To: <9ea470500810080922x326821c5p47053afa7a1d261e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810082037.05889.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008, Boris Petkov wrote:
> On Wed, Oct 8, 2008 at 5:45 PM, Mark de Wever <koraq@xs4all.nl> wrote:
> > On Wed, Oct 08, 2008 at 08:33:52AM +0200, Borislav Petkov wrote:
> > Hi,
> >> Bugger, I should be getting at least warnings when compiling this but I don't.
> >> This is because I don't have CONFIG_LBD enabled. However, the %ld and %d
> >> format specifiers are also not entirely correct but gcc doesn't warn about them
> >> - I guess it checks only size but not signedness...
> >
> > I guess so too.
> >
> >> Would you like to redo your patch and add a proper comment ontop?
> >
> > Here you go.
> >
> > @Boris do you want to add your Signed-off-by too?
> 
> no, just
> 
> Acked-by: Borislav Petkov <petkovbb@gmail.com>
> 
> > @Bart please apply this patch.
> >
> > --
> > Subject: ide-tape: Buildfix when IDETAPE_DEBUG_LOG is set to 1.
> >
> > The format specifier for rq->sector didn't specify the proper size and
> > signedness. Borislav Petkov discovered that the signedness for
> > rq->nr_sectors and rq->current_nr_sectors also were incorrect.
> >
> > Signed-off-by: Mark de Wever <koraq@xs4all.nl>

applied
