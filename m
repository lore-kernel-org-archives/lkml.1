Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYJHCpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYJHCpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYJHCpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:45:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:61688 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbYJHCpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=I6EbnKgpG5Yg/7XIgFDQWvYuWv9b9TL3VzBoHE5DINKA/McKufNsS6K75IcerL1CS/
         qNqJqy18VpANmylgjZnLHhZAl0jixD1AUTp1IKT/EWPHka9WmD3fiL6zBAYymzUINKnu
         qjALWA1TKHqgObDVxalsmUvMcpXs0W/C4f1mg=
Message-ID: <cfd18e0f0810071945j4ebbe366qdf2e98fe3d0306eb@mail.gmail.com>
Date: Wed, 8 Oct 2008 04:45:22 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Kees Cook" <kees.cook@canonical.com>
Subject: Re: [PATCH v2] proc: show personality via /proc/pid/personality
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
In-Reply-To: <20081007161422.GD10357@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081002211424.GJ10632@outflux.net>
	 <20081004145149.52c34ee7@infradead.org>
	 <20081004220220.GK10632@outflux.net>
	 <20081004164239.0c1483a4@infradead.org>
	 <20081005004233.GL10632@outflux.net>
	 <20081004174843.6fe48a8e@infradead.org>
	 <20081005091120.GA21003@x200.localdomain>
	 <20081005101438.GR10632@outflux.net>
	 <517f3f820810070639q549ed2a1pe297e45108dfa007@mail.gmail.com>
	 <20081007161422.GD10357@outflux.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Tue, Oct 7, 2008 at 6:14 PM, Kees Cook <kees.cook@canonical.com> wrote:
> Hi Michael,
>
> On Tue, Oct 07, 2008 at 03:39:26PM +0200, Michael Kerrisk wrote:
>> On Sun, Oct 5, 2008 at 12:14 PM, Kees Cook <kees.cook@canonical.com> wrote:
>> > Make process personality flags visible in /proc.  Since a process's
>> > personality is potentially sensitive (e.g. READ_IMPLIES_EXEC), make this
>> > file only readable by the process owner.
>>
>> Please CC userland interface changes to linux-api@vger.kernel.org
>
> Sure, I'd be happy to do that for future stuff.  I don't see this email
> address mentioned anywhere in the kernel tree.  It seems like this is
> useful information that should go in either MAINTAINERS or better yet
> Documentation/SubmittingPatches for it to be discoverable by future
> patch-senders -- and somewhere that I can look it up easily later.  :)

It's there, but only as of a few days ago.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
