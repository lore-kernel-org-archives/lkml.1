Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZHEV7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZHEV7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZHEV7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:59:13 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:56213 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZHEV7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OLz/x94E/QWAu9ytK5eb8VCZVF9nmrHOH1Qq7/xNiG6uP27GxJ7U0vmTsuPq0e9qND
         On2goKcR8Wcnl8aUH2Muo8Myl1t87+fntlKHTRV1XRWJB7tpnnkkplRzAIXjwoqlfdCP
         gep0+N3UDUkPAgrtwejs+owZNV7bGm+SVEQ6U=
Date: Wed, 5 Aug 2009 23:59:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>, Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [ANNOUNCE] Reiserfs/kill-bkl tree v2
Message-ID: <20090805215904.GB5025@nowhere>
References: <20090731174642.GA6539@nowhere> <20090801081141.GA18036@basil.fritz.box> <20090801155335.GA4836@nowhere> <20090802142100.GA21160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802142100.GA21160@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 04:21:00PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > e.g. running all the file system stress tests from LTP would be 
> > > a good idea, ideally multiple at a time on a multi processor 
> > > system on a ram disk or perhaps AIM9.
> > 
> > Yeah good idea. But again, I fear my laptop hasn't enough memory 
> > to support big enough ramdisks mount points to host selftests.
> 
> Well, dont waste too much time on it (beyond the due diligence 
> level) - Andi forgot that the right way to stress-test patches is to 
> get through the review process and then through the integration 
> trees which have far more test exposure than any single contributor 
> can test.
> 
> Patch submitters cannot possibly test every crazy possibility that 
> is out there - nor should they: it just doesnt scale. What we expect 
> people to do is to write clean patches, to test the bits on their 
> own boxes and submit them to lkml and address specific review 
> feedback.
> 
> 	Ingo

Yeah, I know that doesn't scale. But I really would like to test it, at
least with the minimum scope I have.
Such fundamental change in a filesystem is scary :)

