Return-Path: <linux-kernel-owner+w=401wt.eu-S1763530AbZEHUFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763530AbZEHUFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbZEHUF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:05:26 -0400
Received: from web50112.mail.re2.yahoo.com ([206.190.39.149]:28958 "HELO
	web50112.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762998AbZEHUFW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:05:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xbAPPk/it8BQcSGWXg10GoyKcCQSho60tu5xc5wOC9/Ld6Bo6lMSTJ4yW9dML2bDa7JNx9cDJ6k33HLj27d/ebI32gbQbeJ2q/SjLPAs8F1FRwvL21biouVUIC+boOCOJcpjLoxqrZHYJCVdgBX9zyCgr8Eu2/K5LaeXhpgXcF0=;
Message-ID: <791493.63197.qm@web50112.mail.re2.yahoo.com>
X-YMail-OSG: l5zAqNkVM1nYU.91b7y4Ip9RSXA122XgVdvN5ne65gyHXsw4LLRfkveGHKVRErXmrL6Z0twr0pHs3rujVSSe_b.9Mz4e8EIjtB0Hj8MeHEs5i__9376pE4YfESCtRc2QHNLGFCDCzNPLJDLVq_1IOIivjI7f7m5HBzJuSZnzHtePXH_dlDXuRZALIClt2UOihiBqn87KWUT2f_o2ZAc62AO.bNwWNJWAfIGmq96hVnQTpT3KQHfqyXR2G0Tht_6xalH7ult_uLabA_YjDFhUQBnRh0zd70wfadU-
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Fri, 8 May 2009 13:05:22 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com,
       edt@aei.ca, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Thu, 5/7/09, Ingo Molnar <mingo@elte.hu> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
> To: "Andrew Morton" <akpm@linux-foundation.org>
> Cc: "Borislav Petkov" <borislav.petkov@amd.com>, greg@kroah.com, norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org
> Date: Thursday, May 7, 2009, 3:18 PM
> 
> * Andrew Morton <akpm@linux-foundation.org>
> wrote:
> 
> > On Thu, 7 May 2009 16:38:07 +0200
> > Borislav Petkov <borislav.petkov@amd.com>
> wrote:
> > 
> > > Hi,
> > > 
> > > On Thu, May 07, 2009 at 04:27:24PM +0200, Ingo
> Molnar wrote:
> > > > Regarding workflow, the arch/x86 bits look
> good to me now, so you've 
> > > > got my Acked-by for that.
> > > 
> > > Cool, thanks.
> > > 
> > > Does that mean you're going to pick that one
> or...
> > > 
> > > > Most of the EDAC patches are hosted in 
> > > > -mm, so we could carry them in the x86 tree
> separately as well and 
> > > > export it to linux-next so that -mm will
> have it automatically.
> > > 
> > > is the bunch going through Andrew as a whole?
> > > 
> > 
> > I could.  But there's negligible overlap with
> other EDAC work so 
> > we might as well merge this via IngoTrees or directly
> from your 
> > tree.
> 
> If Doug and you agrees too then i have no problem (at all)
> with 
> Borislav carrying these bits in a separate tree, as long as
> he also 
> opens an edac-next branch for linux-next and asks Stephen
> to pull 
> it, and keeps it an append-mostly tree that isnt rebased.
> 
> [ I still have to do a finegrained review of this lot, a
> quick look
>   suggested i'll have a few minor things to note ;) ]
> 
>     Ingo
> 

I agree, if it removes a burden from some

doug t

