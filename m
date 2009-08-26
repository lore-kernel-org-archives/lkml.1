Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZHZDpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZHZDpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 23:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbZHZDpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 23:45:01 -0400
Received: from tanas.ca ([206.248.136.31]:53026 "EHLO tanas.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621AbZHZDpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 23:45:00 -0400
From: "Andrei Tanas" <andrei@tanas.ca>
To: "'Ric Wheeler'" <rwheeler@redhat.com>
Cc: "'NeilBrown'" <neilb@suse.de>, <linux-kernel@vger.kernel.org>
References: <004e01ca25e4$c11a54e0$434efea0$@ca>    <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>    <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca> <4A94A0E6.4020401@redhat.com>
In-Reply-To: <4A94A0E6.4020401@redhat.com>
Subject: RE: MD/RAID: what's wrong with sector 1953519935?
Date: Tue, 25 Aug 2009 23:45:06 -0400
Message-ID: <005401ca25ff$9ac91cc0$d05b5640$@ca>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acol9tNCukGElqDIRIW4sMtGahjP7gACKuNw
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> I would suggest that Andrei might try to write and clear the IO
> error
> >> at that
> >> offset. You can use Mark Lord's hdparm to clear a specific sector or
> >> just do the
> >> math (carefully!) and dd over it. It the write succeeds (without
> >> bumping your
> >> remapped sectors count) this is a likely match to this problem,
> >
> > I've tried dd multiple times, it always succeeds, and the relocated
> sector
> > count is currently 1 on this drive, even though this particular fault
> > happened at least 3 times so far.
> >
> 
> I would bump that count way up (say to 2) and see if you have an
> issue...

Not sure what you mean by this: how can I artificially bump the relocated
sector count?

