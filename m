Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZGPLE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZGPLE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 07:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZGPLE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 07:04:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51509 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZGPLE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 07:04:56 -0400
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Artem Bityutskiy <dedekind@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-mtd@lists.infradead.org, Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247738232.11353.90.camel@localhost.localdomain>
References: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>
	 <1247640750.11353.6.camel@localhost.localdomain>
	 <4A5E1D1A.3090705@s5r6.in-berlin.de>
	 <1247738232.11353.90.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Thu, 16 Jul 2009 16:34:31 +0530
Message-Id: <1247742274.5572.8.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-07-16 at 12:57 +0300, Artem Bityutskiy wrote:
> On Wed, 2009-07-15 at 20:16 +0200, Stefan Richter wrote:
> > Artem Bityutskiy wrote:
> > > On Wed, 2009-07-15 at 07:49 +0530, Subrata Modak wrote:
> > >> Following fix is inspired by David Howells fix few days back:
> > >> http://lkml.org/lkml/2009/7/9/109,
> > >>
> > >> Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
> > >> ---
> > > 
> > > Removed junk comma at the end of "signed-off-by" and pushed to
> > > the ubifs-2.6.git tree:
> > > 
> > > http://git.infradead.org/ubifs-2.6.git?a=commit;h=5c1507e6097c4abc13bbad69de137366c9043f22
> > > 
> > > Thanks.
> > > 
> > 
> > The changelog of the patch is bad.  "Fix compilation warning" is not 
> > correct.  It should be "suppress compilation warning" or "annotate 
> > unitialized variable" or whatever --- i.e. it should say what it does.

Ok, i would change accordingly.

> 
> For me this sounds the same. But probably your version is better
> English. I'll change this.
> 
> > Furthermore, since the 3 lines context around the change in the diff do 
> > not reveal why the chosen "fix" is correct and desirable, the changelog 
> > should also leave a note why it's done this way.
> 
> The changelog says which kind of warning is fixed, I though it is
> obvious what is the warning. At lease for me it would.
> 
> But if Subrata sends me the warning he sees, I'll change that.
> Thankfully I did not push the patch to ubifs-2.6.git/linux-next
> which I never re-base, but pushed it to master which I do rebase
> and it is documented here:
> http://www.linux-mtd.infradead.org/doc/ubifs.html#L_source

I would resend with exact warning generated, etc.

> 
> So I may just amend the commit's message.
> 
> > The patch form David Howells which is quoted here has an equally bad 
> > subject, but at least its changelog goes on to explain what the patch 
> > really does and why it does it in the proposed way.

Well, untill gcc becomes a little more intelligent, i believe people
would continue to fix them like this way. I would add proper description
in my resend patch.

> 
> Well, I just thought this type of warnings and way of fixing is very
> standard because I saw many similar fixes all over the place.
> 

Correct. There has been other warning fixes i have sent to LKML, where i
have tweaked the code to fix the compilation, but, code tweaking may not
be possible in this case. However , i would  still investigate.

Regards--
Subrata

> Anyway, amended the patch like this so far:
> http://git.infradead.org/ubifs-2.6.git?a=commit;h=5c1507e6097c4abc13bbad69de137366c9043f22
> 

