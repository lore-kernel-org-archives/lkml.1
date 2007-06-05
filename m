Return-Path: <linux-kernel-owner+w=401wt.eu-S1763296AbXFEGRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763296AbXFEGRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 02:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbXFEGQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 02:16:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:46906 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbXFEGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 02:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FaTtv6h4s05kf3gZkCPgCk2mH8UmRIYyQzl9BW+lMnUWLyeSzdEGgHyu+oUo5+wGgPQqeJZ+T8k1keyPmpBincIgGYVsD8Kn0Fi426F9lQvwr3lLu241nTJIgAjuhGBRzNI9xSEroNnel0mAK70kKjpx5HJvoQkmSTCjBrBpK/8=
Message-ID: <4ac8254d0706042316n2b78f7b1y5ed81da50b148e7a@mail.gmail.com>
Date: Tue, 5 Jun 2007 08:16:52 +0200
From: "Tuncer Ayaz" <tuncer.ayaz@gmail.com>
To: "Tim Bird" <tim.bird@am.sony.com>
Subject: Re: Problem with http URL for stable git tree?
Cc: "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <466488C6.3070100@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46646389.7090101@am.sony.com> <20070604211359.GA2046@kroah.com>
	 <466488C6.3070100@am.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Tim Bird <tim.bird@am.sony.com> wrote:
> Greg KH wrote:
> > On Mon, Jun 04, 2007 at 12:10:01PM -0700, Tim Bird wrote:
> >> Greg,
> >>
> >> I'm having problems cloning the stable git tree for 2.6.21.
> >> Here's what I get:
> >>
> >> $ git clone http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git stable-2.6.21.y
> >> Cannot get remote repository information.
> >> Perhaps git-update-server-info needs to be run there?
> >
> > Ick, don't clone by "http://", please use the git protocol instead:
> >       git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git
> >
> > that should work better.
>
> I'm behind a firewall that doesn't allow it.  Luckily, the
> firewall has some holes to allow me ssh access to a few
> external machines.  It looks like I can use a "git:" url on a
> box outside the firewall, then clone that to inside Sony
> with a "git+ssh:" url.
>
> I'll do that, unless someone else has a better suggestion.
> Pushes and pulls will be two steps each, but at least it works.

if you have :22 outbound access you could try git+ssh on git.kernel.org.
I guess you don't have :22 outbound open, do you?
