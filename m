Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXHUSxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXHUSxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760696AbXHUSxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:53:34 -0400
Received: from smtp118.sbc.mail.re3.yahoo.com ([66.196.96.91]:44574 "HELO
	smtp118.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760371AbXHUSxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:53:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WTlQ3YhNIc7jmFwgRGHI8DfHpy9bBudUAnIJJsmRZhAbKrISyTgtmbG5uzNNcgs0ltAlFvQ4qmN5KmP0No2peeZDinEb7xP1WQmoPDoT67lIr+GDaq6mrEDdxmbTdeXt/Vj0WUiBJgtVGZPwhUoP1LC+qtOqfH1vfbWI456eFgY=  ;
X-YMail-OSG: aBLT8nQVM1mGgFDZ4Jo2LLfGvt5mu9CccSM6G712tXq.0Nw7UDjjiMei0sTmBDHjfQSFT0XD2kywQJet6Ztn.KCRRwep9486S90vp19BmWAfaemRgqWaCGVjUKrPqWxP8iLBlXR4tBX0
From: David Brownell <david-b@pacbell.net>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Date: Tue, 21 Aug 2007 11:53:27 -0700
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070819225546.GV21089@ftp.linux.org.uk>
In-Reply-To: <20070819225546.GV21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708211153.27371.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Al Viro wrote:
> Use unsigned long or uintptr_t instead.  There are several places misusing
> ptrdiff_t (one - in a very odd way; WTF did that cast to __user ptrdiff_t 
> in ntfs expect to happen, anyway?)   Fixed...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

By the way:  ACK.  Glad there's now always a "uintptr_t".
