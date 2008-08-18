Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYHRPgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYHRPgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYHRPgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:36:36 -0400
Received: from n72.bullet.mail.sp1.yahoo.com ([98.136.44.34]:45219 "HELO
	n72.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751713AbYHRPgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:36:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 91719.61588.bm@omp208.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=hoXdAKzP2mKMPLyLPEwMJmqv1xTue57u6XZuaGCiLPK/U9MnLsWuuj0uBPgkpYEm7gIwKPbXoUCfNaNQaV31KwAUnD+n4SdNyXsSjfJk/J+WyWzt0J+0RhbTM33y8tmV8lFBPdhKwA/pJabbk7enpHjKzh04cqLpemLB0jPoM5Q=;
X-Mailer: YahooMailWebService/0.7.218
Date: Mon, 18 Aug 2008 08:36:34 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: KGDB 2..26 fails to wait while booting
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48A98193.2010606@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <966386.75458.qm@web45216.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jason. I got it working, but is it possible to enable kdb with kgdb. 
How can I debug the kernel early. In kdb we have option called as kdb=early, can we do the same in kgdb. I tried to set breakpoint in kgdb at start_kernel, it looks like kgdb executed past the start_kernel code.Hence break point does not work.
Please let me know how to enable debug early kernel option in KGDB. 

Thanks
Amruth p.v


--- On Mon, 8/18/08, Jason Wessel <jason.wessel@windriver.com> wrote:

> From: Jason Wessel <jason.wessel@windriver.com>
> Subject: Re: KGDB 2..26 fails to wait while booting
> To: amruth_pv@yahoo.com
> Cc: linux-kernel@vger.kernel.org
> Date: Monday, August 18, 2008, 9:05 AM
> amruth wrote:
> > Hi
> > I have created 2.6.26 kernel with KGDB enabled but the
> system fails to
> wait. Can anybody provide me detailed info on how to setup
> the grub
> configuration to wait until gdb connects from development
> machine.
> > Thanks
> > Amruth p.v
> >
> >
> >      
> >
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> What parameters did you use in grub?
> 
> Generally speaking you have to setup the boot parameters to
> be something
> like:
> 
> kgdboc=ttyS0,115200 kgdbwait
> 
> Jason.
> 
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


      

