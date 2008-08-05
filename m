Return-Path: <linux-kernel-owner+w=401wt.eu-S1762117AbYHEX6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117AbYHEX6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYHEXzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:55:32 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43609 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752463AbYHEXzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:55:31 -0400
Date: Tue, 5 Aug 2008 19:55:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro
	toalinuxinterfaceforonaccess scanning
Message-ID: <20080805235511.GC8224@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net,
	linux-security-module@vger.kernel.org
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805185438.GA8453@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com> <20080805211445.GA28304@kroah.com> <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com> <20080805214415.GA5830@kroah.com> <2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 06:12:34PM -0400, Press, Jonathan wrote:
>  
> I don't think I'm stupid, but frankly I don't understand the point
> of the questions being asked in the last three responses to my
> statement.  I don't know why they are relevant, and I don't know how
> to answer them in a framework that we can all understand at the same
> time.  What is my threat model?  Naively stated, it is that there is
> a file on a machine that might do damage, either there or elsewhere,
> and I want to find it and get rid of it in the most efficient way.
> I am not defining the nature of the damage or the mechanism.

This is actually quite shocking to me.  You don't know how to define
the threat model?  And you call yourself in the security business?
Read some books or essays by Bruce Schneier.  A good one might be his
recent book, "Beyond Fear: Thinking Sensibly About Security In An
Uncertain World".

The naive refusal to think about threat models is why we have to
submit to really insane, useless, "security theater" every time we get
on an Airplane and have to take off our shoes and throw our bottleed
water into a huge heap in front of the security line.  (If they really
thought the water bottles could contain explosives, why leave them in
a huge pile in front of the TSA employees.  :-)

If the goal is to get make we are proof against malware, we need to be
very clear about the whys and wherefores about how the file might have
gotten there.  And if you are going to be serving that file a million
times a day, does it really make sense to block the open a million
times a day, or do you make sure that you notice when it gets
corrupted in the first place?

And security is not an absolute.  Just as the terrorists win if it can
induce the White House to shred the constitution and force us all to
live in a constant state of fear, it is also pointless to induce
people to install software that horrifically slows down their server
so badly that you can't get anything done.

If people in the AV industry don't know how to think about threat
models, it says a lot about their competence as security engineers.
And I say this as someone who was team lead of Kerberos at MIT, and
was the chair of the IP Security working group at the IETF (the
standards body for the Internet), and who has served on the Security
Area Directorate (alongside Bruce Schneier) at the IETF.

     		 	    	  	       	   - Ted
