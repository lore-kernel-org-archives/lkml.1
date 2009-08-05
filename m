Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbZHEWKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbZHEWKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZHEWKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:10:16 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:36968 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZHEWKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xhqBvymBcVIwaM8xf8W5c4OFjCog8/amz2rnYOx5JvEyfWfjYCF9lpOVYRQuPci/Cv
         Eitc5pMFvm4xw5BDurSolXL1aVbUzQXCpd5oZkwqLLgZrdzHuPq/J9vPGMXX5tI6PJaa
         sa9TyX/nctLyc7NkND9s9JU/z9S9170X6iXhk=
Date: Thu, 6 Aug 2009 00:10:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [ANNOUNCE] Reiserfs/kill-bkl tree v2
Message-ID: <20090805221008.GC5025@nowhere>
References: <20090731174642.GA6539@nowhere> <20090801081141.GA18036@basil.fritz.box> <20090801155335.GA4836@nowhere> <20090802142100.GA21160@elte.hu> <y0mzlah238y.fsf@fche.csb> <20090803060944.GB20762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803060944.GB20762@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 08:09:44AM +0200, Ingo Molnar wrote:
> 
> * Frank Ch. Eigler <fche@redhat.com> wrote:
> 
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
> > >> Yeah good idea. But again, I fear my laptop hasn't enough 
> > >> memory to support big enough ramdisks mount points to host 
> > >> selftests.
> > >
> > > Well, dont waste too much time on it (beyond the due diligence 
> > > level) - Andi forgot that the right way to stress-test patches 
> > > is to get through the review process and then through the 
> > > integration trees which have far more test exposure than any 
> > > single contributor can test.
> > 
> > What guideline can you offer as to what is "due diligence" level 
> > of stress testing, as compared to delegating this task to 
> > eyeballed reviews + incidental use on the integration trees?
> 
> The kind of testing the VFS tree itself gets is a good starting 
> point i suspect - and it is a far more critical tree as it can 
> affects all filesystems. AFAICS the VFS tree relies on linux-next 
> and -mm for testing mostly and that's a good model IMO.
> 


I've asked Al Viro to integrate this branch in the VFS tree. He wasn't
opposed to that. Then I sent him the individual patches for integration
in VFS but hadn't any answer since then.

I've kept him cc'ed for any further patches too.

If Al still agrees about this integration, I would be pleased.

Frederic.

