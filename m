Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYBGQBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYBGQBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbYBGQBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:01:37 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:11970 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbYBGQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:01:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type;
        b=ppOmH2TOe1fhGRjjVwXRg4Vodsx2xifR3QUCXRDZhTRUQpnYfOah+Y0x0QxWgH0otPgqSkQZRpaAh+T9UyC0kOWrzXLeB8RHQlahM6LFIgvdwmkA0g2pkBiWgke8pSu2XPDNWTAyMVa5kpSVLTciQLzmreYgVPDG7upCLgTN8nU=
Date: Thu, 7 Feb 2008 11:01:18 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
cc: parag.warudkar@gmail.com, Frank Mayhar <fmayhar@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
In-Reply-To: <20080207165455.04ec490b@Varda>
Message-ID: <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
References: <bug-9906-10286@http.bugzilla.kernel.org/> <20080206165045.89b809cc.akpm@linux-foundation.org> <1202345893.8525.33.camel@peace.smo.corp.google.com> <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net> <20080207162203.3e3cf5ab@Varda>
 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net> <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net> <20080207165455.04ec490b@Varda>
User-Agent: Alpine 1.00 (LRH 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463781375-422654818-1202400085=:29369"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463781375-422654818-1202400085=:29369
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 7 Feb 2008, Alejandro Riveira Fernández wrote:

> El Thu, 7 Feb 2008 10:56:16 -0500 (EST)
> Parag Warudkar <parag.warudkar@gmail.com> escribió:
> 
> > 
> > 
> > On Thu, 7 Feb 2008, Parag Warudkar wrote:
> > 
> > >    x86_64+SMP+PREEMPT+GnuC-4.1.2+Glibc-2.5 = Reproducible.	
> > > 
> > That should of course be   
> >  x86_64+SMP+PREEMPT+GnuC-4.1.3+Glibc-2.6.1 = Reproducible.	
> > 
> From my previous mail 
> 
> Note that i use CC=gcc-4.2 
> 
>  $gcc-4.2 --version
> 
>  gcc-4.2 (GCC) 4.2.1 (Ubuntu 4.2.1-5ubuntu4)
> 
Yep. I will enable PREEMPT and see if it reproduces for me.

Thanks
Parag 
---1463781375-422654818-1202400085=:29369--
