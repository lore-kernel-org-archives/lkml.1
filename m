Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZEPSWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZEPSWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 14:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZEPSWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 14:22:39 -0400
Received: from outbound-mail-308.bluehost.com ([67.222.53.254]:35484 "HELO
	outbound-mail-308.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754075AbZEPSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 14:22:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pb07Hviw4oH1cvBQkfzlIz6KtsN26grrJh5SIOkOou75IB4PBhHw+fezs6fm7pd1Wjm0NW9i6rLElvForKEGb0fkvp8HJXdrFcy7zbbxkLJhLYuPep6Yk4i+dgSbq19M;
Date: Sat, 16 May 2009 11:22:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090516112233.5cb085c8@jbarnes-g45>
In-Reply-To: <m1iqk1k708.fsf@fess.ebiederm.org>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
	<20090513133021.GA7277@elte.hu>
	<4A0ADBA2.2020300@goop.org>
	<20090515182757.GA19256@elte.hu>
	<4A0DCC11.10307@goop.org>
	<m1my9ex818.fsf@fess.ebiederm.org>
	<4A0DFF78.6000501@goop.org>
	<20090515202250.0f1218ef@jbarnes-g45>
	<m1iqk1k708.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 21:26:47 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:
> > FWIW I think supporting the MTRR API in Xen makes sense.  There's a
> > lot of old code out there that wants it; would be nice if it mostly
> > worked, especially at such a minimal cost.  It's taken awhile to
> > get PAT going (and there are still issues here and there) so having
> > the MTRR stuffa available is awfully nice.
> 
> I won't argue that having MTRRs when you can makes sense.  It is a bit
> weird in a vitalized system.  At a practical level there are an
> increasing number of systems for which MTRRs are unusable because the
> BIOS sets up overlapping mtrrs.  With cheap entry level systems
> shipping with 4G I expect it is becoming a majority of systems.

Yeah, MTRRs definitely have issues too; as you say on many recent
machines they're tougher to use.  Either we need to reprogram them to
free some up for WC mappings, or use PAT.  But that's a relatively
recent development (last year or two I think?).

This is really about what software Xen wants to support though.  You
can say, "it would be easier for you to just support new software that
doesn't use MTRRs," and you might be right, but supporting older stuff
doesn't appear that difficult, and it sounds like something they want
to do.

-- 
Jesse Barnes, Intel Open Source Technology Center
